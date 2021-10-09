//
//  AnnouncementView.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/26/21.
//

import SwiftUI
struct AnnouncementsViews: View {
    @EnvironmentObject var session: SessionStore
    var admin: Bool = false
    var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                AnnouncementsView14(hospital: session.userSession!.hospEnum, admin: admin)
            } else {
                AnnouncementsView13(hospital: session.userSession!.hospEnum, admin: admin)
            }
        }
    }
}
@available(iOS 14.0, *)
struct AnnouncementsView14: View {
    @StateObject var announcementsViewModel: AnnouncementsViewModel
    init(hospital: Hospital, admin: Bool = false) {
        _announcementsViewModel = StateObject(wrappedValue: AnnouncementsViewModel(hospital: hospital))
        self.admin = admin
    }
    var admin: Bool = false
    var body: some View {
        AnnouncementsView(announcementsViewModel: announcementsViewModel, admin: admin)
    }
}
struct AnnouncementsView13: View {
    @ObservedObject var announcementsViewModel: AnnouncementsViewModel
    var admin: Bool = false
    init(hospital: Hospital, admin: Bool = false) {
        _announcementsViewModel = ObservedObject(wrappedValue: AnnouncementsViewModel(hospital: hospital))
        self.admin = admin
    }
    var body: some View {
        AnnouncementsView(announcementsViewModel: announcementsViewModel, admin: admin)
    }
}
struct AnnouncementsView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var announcementsViewModel: AnnouncementsViewModel
    var admin: Bool = false
    var body: some View {
        MenuViewComponent() {
            List {
                if announcementsViewModel.isLoading == .loaded {
                    ForEach(0..<announcementsViewModel.announcements.count, id:\.self) {
                        index in
                        ZStack {
                            AnnouncementListRow(announcement: announcementsViewModel.announcements[index].announcement, index: announcementsViewModel.announcements[index].announcement.id!, selected: $announcementsViewModel.selectedAnnouncement)
                            NavigationLink(destination: AnnouncementView(index: index, announcementViewModel: announcementsViewModel.announcements[index], admin: admin).environmentObject(announcementsViewModel), tag: announcementsViewModel.announcements[index].announcement.id!, selection: $announcementsViewModel.selectedAnnouncement) {
                                EmptyView()
                            }
                            .isDetailLink(UIDevice.current.userInterfaceIdiom == .pad ? true : false)
                            .buttonStyle(PlainButtonStyle())
                            .frame(width:0).opacity(0)
                        }
                    }
                } else if announcementsViewModel.isLoading == .loading {
                    Text("Loading...")
                        .listRowBackground(Color.clear)
                        .onAppear(perform: {announcementsViewModel.loadAnnouncements()})
                } else if announcementsViewModel.isLoading == .empty {
                    Text("Empty")
                        .listRowBackground(Color.clear)
                }
            }
            .pullToRefresh(isShowing: $announcementsViewModel.isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.announcementsViewModel.loadAnnouncements()
                    self.announcementsViewModel.isShowing = false
                }
            }
            .alert(isPresented: $announcementsViewModel.showAlert) {
                Alert(title: Text(announcementsViewModel.alertTitle), message: Text(announcementsViewModel.alertMessage), dismissButton: .default(Text(OK)))
            }
        }
        .navigationBarTitle("Announcements", displayMode: .inline)
        .navigationBarColor()
    }
}


struct AnnouncementView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var announcementsViewModel: AnnouncementsViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var announcementViewModel: AnnouncementViewModel
    let index: Int
    var admin: Bool
    init(index: Int, announcementViewModel: AnnouncementViewModel, admin: Bool) {
        self.admin = admin
        self.index = index
        self.announcementViewModel = announcementViewModel
        self.homeViewModel = HomeViewModel(allImages: announcementViewModel.announcement.imgStrings)
//        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        let ann = announcementViewModel.announcement
        return ScrollView(.vertical) {
            VStack{
                if !homeViewModel.allImages.isEmpty {
                    ImageSlider(index: $homeViewModel.indexPhoto.animation(), maxIndex: homeViewModel.allImages.count - 1) {
                        ForEach(homeViewModel.allImages.indices, id:\.self) {index2 in
                            ImageView(urlString: homeViewModel.allImages[index2])
                        }
                    }
                    .aspectRatio(4/3, contentMode: .fit)
                    .clipShape(Rectangle())
                }
                Text(ann.title)
                HStack {
                    Text(ann.dateString)
                    Spacer()
                    Text(ann.status)
                }.padding()
                Divider()
                Text(ann.content)

            }
            Spacer()
            if admin {
                SigninButton(action: {
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    announcementsViewModel.removeAnnouncement(at: index, id: ann.id!, images: ann.photos)
                                }
                }, wait: .constant(false), label: DELETE_ANN, altLabel: PLEASE_WAIT, color: Color.red)
            }
        }
        
        .navigationBarColor()
        .overlay(FocusImageView())
        .environmentObject(homeViewModel)
        .navigationBarTitle(Text(ann.title), displayMode: .inline)
        .alert(isPresented: $announcementViewModel.showAlert) {
            Alert(title: Text(announcementViewModel.alertTitle), message: Text(announcementViewModel.alertMessage), dismissButton: .default(Text(OK)))
        }
        .navigationBarItems(trailing:
                                InactivateButton(admin: admin, ann: ann, index: index) {
                                    announcementViewModel.announcement.status = "inactive"
                                    presentationMode.wrappedValue.dismiss()
                                })
    }
}

struct InactivateButton: View {
    let admin: Bool
    let ann: Announcement
    let index: Int
    var action: () -> Void
    var body: some View {
        if admin {
            if ann.status == "active" {
                Button("Inactivate") {action()}
            }
        }
    }
}


struct AnnouncementListRow: View {
    var announcement: Announcement
    @State var buttonFlash = false
    let index: Int
    @Binding var selected: Int?
    var body: some View {
        VStack {
            HStack{
                Text("Title: ")
                Text(announcement.title)
                Spacer()
            }
            HStack{
                Text("Catogory: ")
                Text(announcement.category)
                Spacer()
            }
        }
        .padding()
        .animation(.default)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.4)))
        .background(!buttonFlash ? Color(UIColor.systemBackground) : Color.blue.opacity(0.25))
        .cornerRadius(20)
        .shadow(radius: 5)
        .simultaneousGesture(TapGesture().onEnded{ _ in colorChange()})
    }
    func colorChange() {
        // first toggle makes it red
        buttonFlash.toggle()
        
        // wait for 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            // Back to normal with ease animation
            withAnimation(.easeIn){
                self.buttonFlash.toggle()
                self.selected = self.index
            }
        })
    }
}
