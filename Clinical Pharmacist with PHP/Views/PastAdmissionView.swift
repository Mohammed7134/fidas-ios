//
//  PastAdmissionView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/12/21.
//

import SwiftUI
@available(iOS 14.0, *)
struct PastAdmissionView14: View {
    @StateObject var pastAdmissionViewModel = PastAdmissionViewModel()
    let patient: Patient
    var body: some View {
        PastAdmissionView(pastAdmissionViewModel: pastAdmissionViewModel, patient: patient)
    }
}
struct PastAdmissionView13: View {
    @ObservedObject var pastAdmissionViewModel = PastAdmissionViewModel()
    let patient: Patient
    var body: some View {
        PastAdmissionView(pastAdmissionViewModel: pastAdmissionViewModel, patient: patient)
    }
}
struct PastAdmissionView: View {
    @EnvironmentObject var patientListViewModel: PatientListViewModel
    @ObservedObject var pastAdmissionViewModel: PastAdmissionViewModel
    let patient: Patient
    @State var reload = false
    var body: some View {
        let admission: PatientAdmission = patient.patientAdmissions[pastAdmissionViewModel.admissionSelection]
        return
            GeometryReader {geometry in
                ZStack(alignment: .center) {
                    ZStack(alignment: .bottomTrailing) {
                        HStack {
                            Spacer()
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 10) {
                                    FirstView(patient: patient, admission: admission, geo: geometry)
                                    LimitedForEach(array: admission.pastMedicalHistory, header: "Past Medical History", geo: geometry) { index in
                                        HStackSpacer(val: admission.pastMedicalHistory[index])
                                    }
                                    LimitedForEach(array: admission.presentingComplaints, header: "Presenting Complaints", geo: geometry) { index in
                                        HStackSpacer(val: admission.presentingComplaints[index])
                                    }
                                    
                                    VStack{
                                        Picker("", selection: $pastAdmissionViewModel.labSelection) {ForEach(["RFT", "LFT"], id:\.self) {Text($0)}}
                                            .pickerStyle(SegmentedPickerStyle())
                                        if pastAdmissionViewModel.labSelection == "RFT" {LabViewOnlyMode(refVals: RefVals.RFT, results: admission.rfts, type: "RFT")}
                                        else if pastAdmissionViewModel.labSelection == "LFT" {LabViewOnlyMode(refVals: RefVals.LFT, results: admission.lfts, type: "LFT")}
                                    }
                                    .gesture(createDragLab())
                                    .modifier(PastAdmissionsModifiers(geometry: geometry))
                                    
                                    VStack{
                                        Picker("", selection: $pastAdmissionViewModel.medSelection) { ForEach(["Home", "Current", "Discharge"], id:\.self) {Text($0)}}
                                            .pickerStyle(SegmentedPickerStyle())
                                        if pastAdmissionViewModel.medSelection == "Home" {MedicineViewOnlyMode(admission: admission, type: "Home")}
                                        else if pastAdmissionViewModel.medSelection == "Current" {MedicineViewOnlyMode(admission: admission, type: "Current")}
                                        else if pastAdmissionViewModel.medSelection == "Discharge" {MedicineViewOnlyMode(admission: admission, type: "Discharge")}
                                    }
                                    .gesture(createDragMed())
                                    .modifier(PastAdmissionsModifiers(geometry: geometry))
                                    
                                    LimitedForEach(array: admission.weights, header: "Weights", geo: geometry) { index in
                                        HStackSpacer(val: "\(admission.weights[index].value) Kg", date: admission.weights[index].dateString)
                                    }
                                    LimitedForEach(array: admission.balances, header: "Fluid Chart", geo: geometry) { index in
                                        HStackSpacer(val: "\(admission.balances[index].sign ?? "")\(admission.balances[index].value) ml", date: admission.balances[index].dateString)
                                    }
                                    LimitedForEach(array: admission.beds, header: "Beds", geo: geometry) { index in
                                        HStackSpacer(val: admission.beds[index].name, date: admission.beds[index].dateString)
                                    }
                                }
                                
                            }
                            Spacer()
                        }
                        if patient.mostRecentAdmission.discharged && !reload {
                            Button(action: {pastAdmissionViewModel.showSheet = true}) {
                                Image("add")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 50, height: 50)
                                    .scaledToFit()
                                    .padding()
                            }
                            .sheet(isPresented: $pastAdmissionViewModel.showSheet, onDismiss: onDismiss) {
                                if #available(iOS 14, *) {
                                    AddAdmission14(patientListViewModel: patientListViewModel, patient: patient)
                                } else {
                                    AddAdmission13(patientListViewModel: patientListViewModel, patient: patient)
                                }
                            }
                        }
                        
                    }
                    if pastAdmissionViewModel.showPicker  {
                        Spacer()
                        VStack(spacing: 0) {
                            Spacer()
                            HStack {
                                Spacer()
                                Button("Done") {pastAdmissionViewModel.showPicker = false}.padding()
                            }
                            .frame(width: geometry.size.width, height: 40)
                            .background(Color.init(UIColor.init(hex: "#bbbbbbFF")!))
                            Divider()
                            Picker(selection: $pastAdmissionViewModel.admissionSelection, label: Text("Admission Date")) {
                                ForEach(0..<patient.patientAdmissions.count) { index in
                                    Text(patient.patientAdmissions[index].admissionDateString)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.3)
                            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
                        }
                    }
                }
            }
            .customedBackground()
            .navigationBarTitle(Text("All Admissions"))
            .navigationBarItems(trailing: Button(action: {pastAdmissionViewModel.showPicker.toggle()}) {Image(systemName: "calendar").padding([.leading, .vertical]).imageScale(.large)})
            
    }
    func changeLabView(left : Bool){
        if left { if pastAdmissionViewModel.labSelection == "RFT" {pastAdmissionViewModel.labSelection = "LFT"} }
        else { if pastAdmissionViewModel.labSelection == "LFT" { pastAdmissionViewModel.labSelection = "RFT"} }
    }
    
    func changeMedView(left : Bool){
        if left { if pastAdmissionViewModel.medSelection == "Home" { pastAdmissionViewModel.medSelection = "Current"} else if pastAdmissionViewModel.medSelection == "Current" { pastAdmissionViewModel.medSelection = "Discharge"} }
        else {if pastAdmissionViewModel.medSelection == "Discharge" { pastAdmissionViewModel.medSelection = "Current" } else if pastAdmissionViewModel.medSelection == "Current" { pastAdmissionViewModel.medSelection = "Home"} }
    }
    func createDragMed() -> _EndedGesture<DragGesture> {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded({ (value) in
                if value.translation.width > 50 {changeMedView(left: false)}
                if -value.translation.width > 50 {changeMedView(left: true) }
            })
    }
    func createDragLab() -> _EndedGesture<DragGesture> {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onEnded({ (value) in
                if value.translation.width > 50 {changeLabView(left: false)}
                if -value.translation.width > 50 {changeLabView(left: true)}
            })
    }
    func onDismiss() {
        if #available(iOS 14, *) {}
        else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if UIDevice.current.orientation.isPortrait {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        reload = true
                    }
                }
            }
        }
    }
}


struct FirstView: View {
    let patient: Patient
    let admission: PatientAdmission
    let geo: GeometryProxy
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .center) {
                Text(patient.patientFileNumber).font(.headline)
            }
            HStack {
                VStack {
                    Text("Admitted on:")
                    Text(admission.admissionDateString).padding(.trailing, -150)
                }.font(.headline)
                Spacer()
                VStack {
                    Text("Ward")
                    Text("\(admission.ward)")
                }.padding().background(Color.blue.opacity(0.2)).clipShape(Circle()).padding(.trailing)
            }.padding(.leading, 20)
            HStack {
                VStack {
                    Text("Discharged on:")
                    Text(admission.dischargeDateString).padding(.trailing, -150)
                }.font(.headline)
                Spacer()
                VStack {
                    Text("Height")
                    Text("\(admission.height, specifier: "%.2f")")
                }.padding().background(Color.blue.opacity(0.2)).clipShape(Circle()).padding(.trailing, 8)
            }.padding(.leading, 20)
        }
        
        .padding(5)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.4)))
        .frame(width: geo.size.width * 0.88)
    }
}
