//
//  PatientListView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/17/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//
import SwiftUIRefresh
import SwiftUI
struct PatientListViews: View {
    var body: some View {
        Group {
            if #available(iOS 14.0, *) {
                PatientListView14()
            } else {
                PatientListView13()
            }
        }
    }
}
@available(iOS 14.0, *)
struct PatientListView14: View {
    @StateObject var patientListViewModel = PatientListViewModel()
    var body: some View {
        PatientListView(patientListViewModel: patientListViewModel)
    }
}
struct PatientListView13: View {
    @ObservedObject var patientListViewModel = PatientListViewModel()
    var body: some View {
        PatientListView(patientListViewModel: patientListViewModel)
    }
}
struct PatientListView: View {
    @ObservedObject var patientListViewModel: PatientListViewModel
    @EnvironmentObject var session: SessionStore
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width > -100 {
                    withAnimation {patientListViewModel.showMenu = false}
                }
            }
        
        return //NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .trailing) {
                    List {
                        if patientListViewModel.isLoading == .loaded {
                            ForEach(0..<patientListViewModel.patients.count, id: \.self) { index in
                                if !patientListViewModel.patients[index].patient.mostRecentAdmission.discharged {
                                    ZStack {
                                        PatientListRow(patient: patientListViewModel.patients[index].patient, index: index, selected: $patientListViewModel.selected)
                                            NavigationLink(destination: PatientView(patientListViewModel: patientListViewModel, patientViewModel: patientListViewModel.patients[index]), tag: index, selection: $patientListViewModel.selected) {
                                                EmptyView()
                                            }
                                            .isDetailLink(UIDevice.current.userInterfaceIdiom == .pad ? true : false)
                                            .buttonStyle(PlainButtonStyle())
                                            .frame(width:0).opacity(0) //you can remove?
                                    }
                                }
                            }.listRowBackground(Color.clear)

                        } else if patientListViewModel.isLoading == .loading {
                            Text(patientListViewModel.message)
                                .listRowBackground(Color.clear)
                                .onAppear(perform: {patientListViewModel.loadPatients()})
                        } else if patientListViewModel.isLoading == .empty {
                            Text(patientListViewModel.message)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .customedBackground()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: patientListViewModel.showMenu ? -geometry.size.width/2 + 50 : 0)
                    .disabled(patientListViewModel.showMenu ? true : false)

                    .onTapGestureInIPhone {withAnimation {if patientListViewModel.showMenu {patientListViewModel.showMenu = false}}}
                    .pullToRefresh(isShowing: $patientListViewModel.isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.patientListViewModel.loadPatients()
                            self.patientListViewModel.isShowing = false
                        }
                    }
                    if patientListViewModel.showMenu {
                        MenuView(count: patientListViewModel.count, showCount: true)
                            .frame(width: geometry.size.width/2 + 50)
                            .transition(.move(edge: .trailing))
                            .onAppear{patientListViewModel.admissionCount()}
                    }

                }.gesture(drag)
            }
            .navigationBarColor()
            .modifier(PatientListViewModifiers(patientListViewModel: patientListViewModel))
//            DefaultView()
//        }.currentDeviceNavigationViewStyle()
    }
}

struct PatientListRow: View {
    var patient: Patient
    @State var buttonFlash = false
    let index: Int
    @Binding var selected: Int?
    var body: some View {
        HStack {
            Circle()
                .stroke(Color.gray)
                .background(patient.mostRecentAdmission.discharged ? Color.pink.opacity(0.4).clipShape(Circle()) : Color.clear.clipShape(Circle()))
                .frame(width: 55, height: 55)
                .overlay(Text(patient.patientInitials).font(.title))
            
            
            VStack(alignment: .leading, spacing: 10){
                Text(patient.patientFileNumber)
                HStack(spacing: 20) {
                    Text("W: \(patient.mostRecentAdmission.ward)").font(.subheadline)
                    Text("B: \(patient.mostRecentAdmission.beds.last?.name ?? "NA")").font(.subheadline)
                }
            }.lineLimit(1)
            Spacer()
            VStack{
                Text("adm:").font(.caption)
                Text(patient.mostRecentAdmission.timesAgoSinceAdmission).font(.caption)
            }
        }
        .padding()
        .animation(.default)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.4)))
        .background(!buttonFlash ? Color(UIColor.systemBackground) : Color.blue.opacity(0.25))
        .cornerRadius(20)
        .shadow(radius: 5)
        .simultaneousGesture(TapGesture().onEnded{ x in colorChange()})
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



