//
//  LimitedViewArray.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 3/12/21.
//

import SwiftUI

struct LimitedForEach<Content: View>: View {
    let array: [Any]
    let header: String
    @State var num: Int = 3
    let showLimit = 3
    let geo: GeometryProxy
    let content: (Int) -> Content

    var body: some View {
        
        if !array.isEmpty {
                VStack(alignment: .leading) {
                    Text(header).font(.body)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(0..<array.count, id:\.self) {index in
                                content(index).frame(minWidth: 100).font(.subheadline).padding().background(Color.blue.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 20)).padding(.trailing)
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.4)))
                .frame(width: geo.frame(in: .global).width * 0.88)
            
        } else {
            EmptyView()
        }
    }
}
struct HStackSpacer: View {
    let val: String
    var date: String = ""
    var body: some View {
        HStack {
            Text(val)
            Spacer()
            Text(date)
        }
    }
}
