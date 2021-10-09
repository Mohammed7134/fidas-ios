//
//  MenuViewComponent.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 6/4/21.
//

import SwiftUI
struct MenuViewComponent<Content: View>: View {
    let content: Content
    @State var showMenu: Bool = false
    @State var pad: CGFloat = 0
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                content.disabled(showMenu ? true : false)
                if showMenu {
                    MenuView(count: 0)
                        .frame(width: geometry.size.width/2 + 50)
                        .transition(.move(edge: .trailing))
                        .padding(.trailing, pad)
                }
            }.gesture(drag(geometry: geometry))
            
            .onAppear{showMenu = false}
            .navigationBarItems(trailing: togglingMenuButton(geometry: geometry))
        }
    }
    
    
    func togglingMenuButton(geometry: GeometryProxy) -> some View {
        Button(action: {togglingMenu(geometry: geometry)})
            {Image(systemName: "line.horizontal.3").padding([.vertical, .leading]).imageScale(.large)}
    }
    func drag(geometry: GeometryProxy) -> _EndedGesture<DragGesture> {
       return DragGesture()
            .onEnded {
                if $0.translation.width > -100 {
                    togglingMenu(geometry: geometry)
                }
            }
    }
    func togglingMenu(geometry: GeometryProxy) {
        if !showMenu {
            withAnimation {showMenu.toggle()}
        } else {
            withAnimation{
                pad = -(geometry.size.width/2 + 50)}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showMenu = false
                pad = 0
            }
        }
    }
}
