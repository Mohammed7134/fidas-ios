//
//  Modifiers.swift
//  LikeInstagram
//
//  Created by Mohammed Almutawa on 9/28/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
import Combine
//struct ListSeparatorStyle: ViewModifier {
//
//    let style: UITableViewCell.SeparatorStyle
//
//    func body(content: Content) -> some View {
//        content
//            .onAppear() {
//                if UIDevice.current.userInterfaceIdiom == .phone {
//                    UITableView.appearance().separatorStyle = self.style
//                } else {
//                    UITableView.appearance().separatorStyle = .singleLine
//                }
//            }
//    }
//}


struct SearchFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .padding(10)
            .background(COLOR_LIGHT_GRAY)
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .border(COLOR_LIGHT_GRAY, width: 1)
            .padding([.leading, .trailing, .top])
    }
}

struct PatientListViewModifiers: ViewModifier {
    @ObservedObject var patientListViewModel: PatientListViewModel
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text("My Patients"), displayMode: .inline)
            .navigationBarItems(trailing: TrialingButtons(patientListViewModel: patientListViewModel))
    }
}
struct TrialingButtons: View {
    @ObservedObject var patientListViewModel: PatientListViewModel
    var body: some View {
        HStack {
            ZStack {
                Button(action: {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        if !patientListViewModel.isActive {
                            patientListViewModel.selected = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.patientListViewModel.isActive = true
                            }
                        }
                    } else {
                        self.patientListViewModel.isActive = true
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .imageScale(.large)
                })
                if #available(iOS 14, *) {
                    NavigationLink(destination: SearchPatientsView14(), isActive: $patientListViewModel.isActive) {EmptyView()}
                } else {
                    NavigationLink(destination: SearchPatientsView13(), isActive: $patientListViewModel.isActive) {EmptyView()}
                }
            }
            Button(action: {withAnimation {patientListViewModel.showMenu.toggle()}})
               {Image(systemName: "line.horizontal.3").padding().imageScale(.large)}
        }
    }
}
struct SigninButtonModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(5)
            .shadow(radius: 10, x: 0, y: 10)
            .padding()
    }
}

struct NavigationBarModifier: ViewModifier {
    init(color: UIColor) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = color
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
//            VStack {
//                GeometryReader { geometry in
//                    Color(UIColor(hex: NAVIGATION_BAR_COLOR_HEX)!)
//                        .frame(height: geometry.safeAreaInsets.top )
//                        .edgesIgnoringSafeArea(.all)
//                    Spacer()
//                }
//            }
        }
    }
}


func ColorFromRGB(rgb: UInt) -> Color {
    return Color(
        red: Double((rgb & 0xFF0000) >> 16) / 255.0,
        green: Double((rgb & 0x00FF00) >> 8) / 255.0,
        blue: Double(rgb & 0x0000FF) / 255.0
    )
}

struct Palette {
    /* Put all your colors here */
    
    /* And your gradients! */
    static let backgoundGradient = Gradient(colors: [
        Color.init(UIColor(hex: BACKGROUND_GRADIENT_1)!), Color.init(UIColor(hex: BACKGROUND_GRADIENT_2)!)
    ])
    static let headerGradient = Gradient(colors: [
        Color.init(UIColor(hex: HEADER_GRADIENT_1)!), Color.init(UIColor(hex: HEADER_GRADIENT_2)!)
    ])
}


struct HeaderBackground: View {
    var body: some View {
        let background = LinearGradient(
            gradient: Palette.headerGradient,
            startPoint: .topLeading, endPoint: .bottomTrailing)
        
        return Group {
            Rectangle()
                .fill(background)
                .edgesIgnoringSafeArea(.top)
            Circle()
                .frame(width: 180, height: 180)
                .foregroundColor(.white)
                .opacity(0.17)
                .position(x: 0, y: 0)
            GeometryReader { geometry in
                Circle()
                    .frame(width: 92, height: 92)
                    .foregroundColor(.white)
                    .opacity(0.17)
                    .position(x: geometry.size.width - 20, y: 30)
            }
        }
    }
}

struct CustomViewModefier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Palette.backgoundGradient, startPoint: .top, endPoint: .bottom)//.opacity(0.3)
            content
        }.edgesIgnoringSafeArea([.horizontal, .bottom])
        
    }
}


struct PastAdmissionsModifiers: ViewModifier {
    let geometry: GeometryProxy
    func body(content: Content) -> some View {
        content
            .frame(width: geometry.frame(in: .local).width * 0.88, height: geometry.frame(in: .local).height * 0.4)
            .background(Color(UIColor.systemBackground))
            .animation(.default)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.4)))
    }
}


struct CustomedLeadingPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, UIDevice.current.orientation.isLandscape ? 20 : 0)
    }
}


//struct KeyboardAdaptive1: ViewModifier {
//    @State private var bottomPadding: CGFloat = 0
//    
//    func body(content: Content) -> some View {
//        // 1.
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.bottomPadding)
//                // 2.
//                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
//                    // 3.
//                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
//                    // 4.
//                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
//                    // 5.
//                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
//            }
//            // 6.
//            .animation(.easeOut(duration: 0.16))
//        }
//    }
//}


struct CustomedListRowBackground: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
        } else {
            content
                .listRowBackground(Color(UIColor.systemBackground))
        }
    }
}

struct CustomedOnTapGesture: ViewModifier {
    let action: () -> Void
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    @ViewBuilder
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content
        } else {
            content
                .onTapGesture {action()}
        }
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture(minimumDistance: 25, coordinateSpace: .global).onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content
            .gesture(gesture)
    }
}

struct AdaptsToSoftwareKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight - 40)
            .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }
    private func subscribeToKeyboardEvents() {
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillShowNotification
        ).compactMap { notification in
            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        }.map { rect in
            rect.height
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillHideNotification
        ).compactMap { notification in
            CGFloat.zero
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
}

struct AdaptsToSoftwareKeyboard2: ViewModifier {
    @State var currentHeight: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .offset(y: currentHeight == 0 ? 0 : -50)
            .onAppear(perform: subscribeToKeyboardEvents)
            
        
    }
    private func subscribeToKeyboardEvents() {
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillShowNotification
        ).compactMap { notification in
            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        }.map { rect in
            rect.height
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillHideNotification
        ).compactMap { notification in
            CGFloat.zero
        }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
}
