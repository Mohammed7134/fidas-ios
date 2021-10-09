//
//  TextFieldsView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/19/21.
//

import SwiftUI

struct AddingTextFieldsView<Model>: View where Model: ItemViewModel {
    @ObservedObject var viewModel: Model
    var body: some View {
        BedWardFields(viewModel: viewModel)
        if UIDevice.current.userInterfaceIdiom == .pad {
            HeightWeightIpad(viewModel: viewModel)
        } else {
            HeightWeightIphone(viewModel: viewModel)
        }
    }
}

struct BedWardFields<Model>: View where Model: ItemViewModel {
    @ObservedObject var viewModel: Model
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    Text("Bed:").fixedSize()
                    CustomTextField("(required)", rules: Rules.bedAndWardAndFn, text: $viewModel.bed, error: $viewModel.errorBed, keyType: .alphabet, limitCharacters: 6)
                }.frame(maxWidth: geometry.frame(in: .local).width * 0.5).clipped()
                Divider()
                HStack {
                    Text("Ward:").fixedSize()
                    CustomTextField("(required)", rules: Rules.bedAndWardAndFn, text: $viewModel.ward, error: $viewModel.errorWard, keyType: .alphabet, limitCharacters: 6)
                }.frame(maxWidth: geometry.frame(in: .local).width * 0.5).clipped()
            }
        }
    }
}

struct HeightWeightIpad<Model>: View where Model: ItemViewModel {
    @ObservedObject var viewModel: Model
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    Text("Height:").fixedSize()
                    CustomTextField("(optional)", rules: Rules.weightAndHeightAndBalance, text: $viewModel.height, error: $viewModel.errorHeight, keyType: .decimalPad, limitCharacters: 6, optional: true)
                    Spacer()
                    Text("cm")
                }.frame(maxWidth: geometry.frame(in: .local).width * 0.5).clipped()
                Divider()
                HStack {
                    Text("Weight:").fixedSize()
                    CustomTextField("(optional)", rules: Rules.weightAndHeightAndBalance, text: $viewModel.weight, error: $viewModel.errorWeight, keyType: .decimalPad, limitCharacters: 6, optional: true)
                    Spacer()
                    Text("Kg")
                }.frame(maxWidth: geometry.frame(in: .local).width * 0.5).clipped()
            }
        }
    }
}

struct HeightWeightIphone<Model>: View where Model: ItemViewModel{
    @ObservedObject var viewModel: Model
    var body: some View {
        HStack {
            Text("Height:").fixedSize()
            CustomTextField("(optional)", rules: Rules.weightAndHeightAndBalance, text: $viewModel.height, error: $viewModel.errorHeight, keyType: .decimalPad, limitCharacters: 6, optional: true)
            Spacer()
            Text("cm")
        }
        HStack {
            Text("Weight:").fixedSize()
            CustomTextField("(optional)", rules: Rules.weightAndHeightAndBalance, text: $viewModel.weight, error: $viewModel.errorWeight, keyType: .decimalPad, limitCharacters: 6, optional: true)
            Spacer()
            Text("Kg")
        }
    }
}
