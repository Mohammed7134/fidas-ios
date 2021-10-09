//
//  MedicinesReports.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/17/21.
//

import SwiftUI

struct MedicinesReports: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var adminViewModel: AdminViewModel
    var body: some View {
        NavigationView{
            VStack{
                List{
                    if !adminViewModel.isLoading {
                        ForEach(adminViewModel.reports) { report in
                            NavigationLink(destination: ModifyLocation(adminViewModel: adminViewModel, report: report)) {
                                ReportRow(report: report)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text(PENDING_REPORTS), displayMode: .inline)
            .navigationBarItems(trailing: ExitButton())
            .alert(isPresented: $adminViewModel.showAlert) {
                Alert(title: Text(adminViewModel.alertTitle), message: Text(adminViewModel.alertMessage), dismissButton: .default(Text(OK)))
            }
            .onAppear{if adminViewModel.reports.isEmpty{adminViewModel.loadLocationsReports()}}
        }
    }
}

struct ModifyLocation: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var adminViewModel: AdminViewModel
    
    let report: Report
    var body: some View {
        
        VStack {
            Text(report.medicine.name).padding(.top)
            Picker("", selection: $adminViewModel.selectedLocation) {
                ForEach(LOCATIONS, id: \.self) {Text($0)}
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            if !report.medicine.locations[adminViewModel.selectedLocation]!.isEmpty {
                Text("Current location: \(report.medicine.locations[adminViewModel.selectedLocation] ?? "nil")").padding()
            }
            Text("Change \(adminViewModel.selectedLocation)")
                .padding()
                .background(Color.blue.opacity(0.5))
                .cornerRadius(5)
                .onTapGesture{withAnimation{adminViewModel.showPickers.toggle()}}
            if adminViewModel.showPickers {
                GeometryReader { geometry in
                    HStack {
                        Picker("", selection: $adminViewModel.firstPart) {
                            ForEach(LOC_CODES, id: \.self) {Text($0)}
                        }
                        .frame(maxWidth: geometry.size.width / 3)
                        .clipped()
                        Picker("", selection: $adminViewModel.secondPart) {
                            ForEach(0..<60) {Text("\($0)")}
                        }
                        .frame(maxWidth: geometry.size.width / 3)
                        .clipped()
                        Picker("", selection: $adminViewModel.thirdPart) {
                            ForEach(["", "A", "B", "C", "D", "E", "F"], id: \.self) {Text("\($0)")}
                        }
                        .frame(maxWidth: geometry.size.width / 3)
                        .clipped()
                    }
                    .padding(.horizontal)
                }
                .frame(height: 150)
            }
            if adminViewModel.showPickers {
                SigninButton(action: {adminReportAction(delete: false)}, wait: $adminViewModel.isLoading, label: SUBMIT, altLabel: PLEASE_WAIT)
            }
            Spacer()
            SigninButton(action: {adminReportAction(delete: true)}, wait: .constant(false), label: DELETE_REPORT, altLabel: PLEASE_WAIT, color: Color.red)
        }
        
    }
    
    func adminReportAction(delete: Bool) {
        adminViewModel.adminReportAction(medicine: report.medicine, delete: delete, report: report) {presentationMode.wrappedValue.dismiss()}
    }
}

struct ReportRow: View {
    let report: Report
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(report.medicine.name).font(.subheadline).bold()
//            Text(report.hospital).font(.subheadline)
            Text(report.medicine.pharmacy).font(.subheadline)
            Text("\(report.date)").font(.subheadline).bold()
        }
        .padding()
    }
}
