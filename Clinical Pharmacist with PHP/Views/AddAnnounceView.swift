//
//  AnnounceView.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/29/21.
//

import SwiftUI

struct AddAnnounceView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var adminViewModel: AdminViewModel
    @State private var height: CGFloat?
    @State var showPicker = false
    @State var image = Image("image-placeholder")
    @State var switchView = false
    
    let minHeight: CGFloat = 15
    @State private var flipped = false
//    @State private var animate3d = false
    var body: some View {
        NavigationView {
            Group {
                ZStack {
//                if switchView {
                    AnnouncementsViews(admin: true).opacity(flipped ? 0.0 : 1.0)
//                }
//                else {
                    ScrollView(.vertical) {
                        VStack{
                            TextField("category", text: $adminViewModel.category)
                                .modifier(TextFieldModifier())
                            TextField("title", text: $adminViewModel.title)
                                .modifier(TextFieldModifier())
                            HStack(alignment: .top) {
                                TextView(text: $adminViewModel.content, textDidChange: self.textDidChange)
                                Button(action:{self.showPicker = true}, label: {Image(systemName: "camera.fill").padding(.top, 6).font(.title)}).padding(.trailing) //alignment: .topLeading
                            }
                            .frame(height: height ?? minHeight)
                            .modifier(TextFieldModifier())
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(0..<adminViewModel.imagesData.count, id:\.self) { index in
                                        Image(uiImage: UIImage(data: adminViewModel.imagesData[index])!)
                                            .resizable()
                                            .overlay(
                                                Button(action:{adminViewModel.imagesData.remove(at: index)},
                                                       label: {
                                                        Image(systemName: "x.circle.fill")
                                                            .font(.headline)
                                                            .offset(x: 7, y: -5)
                                                            .foregroundColor(.red)
                                                       }
                                                )
                                                
                                                , alignment: .topTrailing
                                            )
                                            .frame(width: 75, height: 75)
                                            .padding(10)
                                    }
                                }
                            }
                            
                            
                            SigninButton(action: {
                                adminViewModel.writeAnnouncement(hospit: session.userSession!.hospEnum.hpName(), author: session.userSession!.username)
                            }, wait: $adminViewModel.isLoading, label: SUBMIT, altLabel: PLEASE_WAIT)
                            Spacer()
                        }
                    }.opacity(flipped ? 1.0 : 0.0)
                }.modifier(FlipEffect(flipped: $flipped, angle: adminViewModel.animate3d ? 180 : 0, axis: (x: 1, y: 0)))
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(showImagePicker: $showPicker, pickedImage: $image, imagesData: $adminViewModel.imagesData)
            }
            .navigationBarTitle(Text("New Announcement"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                withAnimation(Animation.linear(duration: 0.8)) {
                    adminViewModel.animate3d.toggle()
                }
            }, label: {
                Image(systemName: "arrow.right.arrow.left").imageScale(.large).foregroundColor(.white).padding([.vertical, .trailing])
            }), trailing: ExitButton())
            .alert(isPresented: $adminViewModel.showAlert) {
                Alert(title: Text(adminViewModel.alertTitle), message: Text(adminViewModel.alertMessage), dismissButton: .default(Text(OK)))
            }
        }
    }
    func textDidChange(_ textView: UITextView) {
        self.height = max(textView.contentSize.height, minHeight)
    }
}

