//
//  ContentView.swift
//  SlideMenu_SwiftUI
//
//  Created by 豊岡正紘 on 2020/10/31.
//
import SwiftUI

struct HomeView: View {
    
    @State var showMenu: Bool = false

    let menuWidth = UIScreen.main.bounds.width * 0.7
    
    /// homeのx座標
    @State var xPosition: CGFloat = 0
    @State var isDrag: Bool = false
    
    var drag: some Gesture {
        DragGesture()
            .onChanged{ value in
                isDrag = true
            
                // 移動しすぎないように最大値と最小値の設定
                if showMenu {
                    xPosition = max(min(menuWidth + value.location.x - value.startLocation.x, menuWidth), 0)
                } else {
                    xPosition = max(min(value.location.x - value.startLocation.x, menuWidth), 0)
                }
            }
            .onEnded{ value in
                
                // Dragが終了したタイミングで開くか、閉じるかを判定したい
                if value.location.x - value.startLocation.x >= menuWidth / 3 {
                    showMenu = true
                } else if -(value.location.x - value.startLocation.x) >= menuWidth / 3 {
                    showMenu = false
                }
                isDrag = false
            }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 60) {
                    AvatarView(showMenu: $showMenu)
                    Spacer()
                }
                .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: isDrag ? xPosition : (showMenu ? menuWidth : 0))
            .animation(.easeInOut(duration: 0.2))
            .background(Color.blue)
            .onTapGesture {
                if showMenu {
                    showMenu.toggle()
                }
            }
            .gesture(drag)

            SlideMenuView(showMenu: $showMenu)
                .frame(width: menuWidth, height: geometry.size.height)
                .offset(x: isDrag ? -menuWidth + xPosition : (showMenu ? 0 : -menuWidth))
                .animation(.easeInOut(duration: 0.2))
                .gesture(drag)

        }
    }
}

struct AvatarView: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        Button(action: {
            self.showMenu.toggle()
            
        }) {
            Color.yellow
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
    }
}


struct SlideMenuView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            MenuRow(showMenu: $showMenu, title: "Account", icon: "gear")
            MenuRow(showMenu: $showMenu, title: "Billing", icon: "creditcard")
            MenuRow(showMenu: $showMenu, title: "Sign out", icon: "person.crop.circle")
            Spacer()

        }
        .background(Color.white)
    }
}

struct MenuRow: View {
    @Binding var showMenu: Bool
    
    var title: String
    var icon: String
    
    var body: some View {
        
        Button(action: {
            self.showMenu.toggle()
            
        }) {
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                    .imageScale(.large)
                    .frame(width: 32, height: 32)
                
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(width: 120, alignment: .leading)
                Spacer()
            }
            .padding(.horizontal, 30)

        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
