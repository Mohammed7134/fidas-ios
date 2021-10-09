//
//  MainView.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 6/3/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        NavigationView {
            MenuViewComponent() {
                VStack(spacing: 40){
                    Image(IMAGE_LOGO).resizable().aspectRatio(contentMode: .fill).frame(width: 250, height: 250)
//                    HStack{
//                        Spacer()
//                        ButtonInMain(systemName: "person.3.fill", label: "Follow-up", active: $session.showFollowUpView) {
//                            PatientListViews().environmentObject(session)
//                        }
//
//                        Spacer()
//                        ButtonInMain(systemName: "envelope.open", label: "Announcements", active: $session.showAnnouncementsView) {
//                            AnnouncementsViews().environmentObject(session)
//                        }
//                        Spacer()
//                    }
//                    HStack{
//                        Spacer()
                        ButtonInMain(systemName: "location.fill", label: "Find Medicine", active: $session.showFindMedicineView) {SearchLocationView(hospital: session.userSession!.hospEnum)
                        }
                        
                        Spacer()
//                        ButtonInMain(systemName: "lightbulb", label: "Information", active: $session.showInfoView) {
//                            Text("Coming soon").environmentObject(session)
//                        }
                        
//                        Spacer()
//                    }
                }
                .navigationBarColor()
                .navigationBarTitle("Home", displayMode: .large)
            }
        }
        .currentDeviceNavigationViewStyle()
        
        
    }
}
struct ButtonInMain<Content: View>: View {
    let view: Content
    let systemName: String
    let label: String
    @Binding var active: Bool
    init(systemName: String, label: String, active: Binding<Bool>, @ViewBuilder view: () -> Content) {
        self.view = view()
        self.systemName = systemName
        self.label = label
        self._active = active
    }
    var body: some View {
        NavigationLink(destination: view, isActive: $active) {
            VStack{
                Image(systemName: systemName)
                    .imageScale(.large)
                    .padding(5)
                Text(label)
            }
            .padding(4)
            .frame(width: UIScreen.main.bounds.width - 20, height: 150)
            .background(Color.gray.opacity(0.01))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(UIColor(hex: "#000080ff")!).opacity(1), lineWidth: 3).shadow(radius: 10))
            
            
            
        }
    }
}
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
