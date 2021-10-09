//
//  LoadingView.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/15/21.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            Image(IMAGE_LOGO)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .opacity(isLoading ? 1 : 0.3)
        }
        .onAppear() {
            withAnimation(Animation.easeIn(duration: 1).repeatForever()){self.isLoading = true}
        }
    }
}

