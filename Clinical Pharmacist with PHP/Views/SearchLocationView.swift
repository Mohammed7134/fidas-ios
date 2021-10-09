//
//  SearchLocationView.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/16/21.
//

import SwiftUI
struct SearchLocationView: View {
    @State var showMenu = false
    @ObservedObject var searchLocationViewModel: SearchViewModel
    init(hospital: Hospital) {
        self.searchLocationViewModel = SearchViewModel(hospital: hospital)
    }
    var body: some View {
        MenuViewComponent() {
            ZStack {
                VStack(spacing: 0) {
                    TextField("Search medicine location", text: $searchLocationViewModel.searchText, onCommit: {searchLocationViewModel.getLocation(medicine: searchLocationViewModel.searchText)})
                        .keyboardType(.alphabet)
                        .modifier(SearchFieldModifier())
                        .overlay(
                            Button(action:{searchLocationViewModel.searchText = ""}, label: {
                                if !searchLocationViewModel.searchText.isEmpty {
                                    Image(systemName: "xmark.circle.fill").imageScale(.large).foregroundColor(.gray).padding(.trailing)}
                            }).padding(), alignment: .trailing
                        )
                    
                    List {
                        if searchLocationViewModel.medicines.isEmpty {
                            Text("Empty List")
                        } else {
                            ForEach(searchLocationViewModel.medicines) { med in
                                MedicineLocationsRow(med: med)
                                    .contextMenu {
                                        Button(action: {reportLocation(med: med)}) {
                                            HStack {
                                                Text("Report")
                                                Image(systemName: "doc.plaintext")
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                .disabled(searchLocationViewModel.choosePlace)
                .alert(isPresented: $searchLocationViewModel.showAlert) {
                    Alert(title: Text(searchLocationViewModel.alertTitle), message: Text(searchLocationViewModel.alertMessage), dismissButton: .default(Text(OK)))
                }
                .overlay(
                    Button(searchLocationViewModel.choosePlace ? "" : "Change") {searchLocationViewModel.choosePlace = true}
                        .padding(.horizontal)
                        .background(searchLocationViewModel.choosePlace ? Color.clear : Color(UIColor(hex: "#add8e6ff")!))
                        .cornerRadius(5)
                        .shadow(radius: 5)
                    , alignment: .bottomTrailing
                )
                if searchLocationViewModel.choosePlace {
                    Color.gray.opacity(0.7).edgesIgnoringSafeArea(.bottom)
                    GeometryReader { geometry in
                        VStack {
                            PharmacyPicker(hospital: $searchLocationViewModel.hospital, pharmacy: $searchLocationViewModel.pharmacy)
                            if locationChosen() {
                                SigninButton(action: {searchLocationViewModel.choosePlace = false}, wait: .constant(false), label: "Find", altLabel: PLEASE_WAIT)
                            }
                        }
                        .padding(.vertical)
                        .frame(width: geometry.size.width * 0.96)
                        .background(Color(UIColor(hex: "#add8e6ff")!))
                        .cornerRadius(5)
                        .shadow(radius: 5)
                    }
                }
            }
            .navigationBarTitle("Search location", displayMode: .inline)
        
            .navigationBarColor()
        }
    }
    func reportLocation(med: MedicineLocations) {
        searchLocationViewModel.reportLocation(medicine: med)
    }
    func locationChosen() -> Bool {
        withAnimation {
            searchLocationViewModel.hospital != .Empty && !searchLocationViewModel.pharmacy.isEmpty
        }
    }
}

struct MedicineLocationsRow: View {
    let med: MedicineLocations
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(med.name)
                .font(.subheadline).bold()
                .fixedSize(horizontal: false, vertical: true)
            HStack{
                Text(med.locations["location1"]!);Divider()
                Text(med.locations["location2"]!);Divider()
                Text(med.locations["location3"]!);Divider()
                Text(med.locations["location4"]!)
            }
        }
        .padding()
        .listRowBackground(med.locations["location1"]!.hasPrefix("BF") ? Color.blue.opacity(0.4) : Color.clear)
    }
}
