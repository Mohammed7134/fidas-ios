//
//  HeaderView.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        Group{
            Image(IMAGE_LOGO).resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150)
            Divider()
        }
    }
}
