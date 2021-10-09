//
//  SearchPatientsView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/11/21.
//
import SwiftUIRefresh
import SwiftUI
@available(iOS 14.0, *)
struct SearchPatientsView14: View {
    @StateObject var patientListViewModel = PatientListViewModel()
    var body: some View {
        SearchPatientsView(patientListViewModel: patientListViewModel)
    }
}
struct SearchPatientsView13: View {
    @ObservedObject var patientListViewModel = PatientListViewModel()
    var body: some View {
        SearchPatientsView(patientListViewModel: patientListViewModel)
    }
}
struct SearchPatientsView: View {
    @ObservedObject var patientListViewModel: PatientListViewModel
    @State var isFirstResponder = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
                    TextFieldWithFocus(text: $patientListViewModel.searchText, placeholder: "Search", isFirstResponder: $isFirstResponder, limitCharacters: 20, showToolBar: false, onCommit: {hideKeyboard()})
                        .frame(height: 10)
                }
                .modifier(SearchFieldModifier())
                Spacer()
                ZStack(alignment: .center) {
                    if patientListViewModel.isLoading == .loaded {
                        List{
                            ForEach(patientListViewModel.patients) { patientVM in
                                ZStack{
                                    PatientListRow(patient: patientVM.patient, index: patientVM.patient.patientId!, selected: $patientListViewModel.selectedFromSearch)
                                    if #available(iOS 14, *) {
                                        NavigationLink(destination: PastAdmissionView14(patient: patientVM.patient).environmentObject(patientListViewModel), tag: patientVM.patient.patientId!, selection: $patientListViewModel.selectedFromSearch) {
                                            EmptyView()
                                        }
                                        .isDetailLink(UIDevice.current.userInterfaceIdiom == .pad ? true : false)
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width:0).opacity(0)
                                    } else {
                                        NavigationLink(destination: PastAdmissionView13(patient: patientVM.patient).environmentObject(patientListViewModel), tag: patientVM.patient.patientId!, selection: $patientListViewModel.selectedFromSearch) {
                                            EmptyView()
                                        }
                                        .isDetailLink(UIDevice.current.userInterfaceIdiom == .pad ? true : false)
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }.listRowBackground(Color.clear)
                            }
                        }
                        .pullToRefresh(isShowing: $patientListViewModel.isShowing) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.patientListViewModel.isShowing = false
                                self.patientListViewModel.searchTextDidChange()
                            }
                        }
                    } else if patientListViewModel.isLoading == .loading {
                        Text("Loading...")
                            .onAppear(perform: {patientListViewModel.searchTextDidChange()})
                    } else if patientListViewModel.isLoading == .empty {
                        if #available(iOS 14, *) {
                            VStack {
                                NavigationLink(destination: PatientInputView14().environmentObject(patientListViewModel)) {Circle().frame(width: 80, height: 80).foregroundColor(Color.gray.opacity(0.4)).overlay(Image(systemName: "plus").font(.largeTitle))}
                                Text("Add new patient").foregroundColor(.white)
                            }.padding(.bottom, 200)
                        } else {
                            VStack {
                                NavigationLink(destination: PatientInputView13().environmentObject(patientListViewModel)) {Circle().frame(width: 80, height: 80).foregroundColor(Color.gray.opacity(0.4)).overlay(Image(systemName: "plus").font(.largeTitle))}
                                Text("Add new patient").foregroundColor(.white)
                            }.padding(.bottom, 200)
                        }
                    }
                }
                Spacer()
            }
            .customedBackground()
            .navigationBarTitle("Search Patients")
        }
    }
}

