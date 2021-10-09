//
//  ImageViewer.swift
//  Fidas
//
//  Created by Mohammed Almutawa on 5/31/21.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @ObservedObject var urlImageModel: UrlImageModel
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    homeData.selectedImageID = urlImageModel.urlString ?? "image-placeholder"
                    homeData.showImageViewer.toggle()
                }
            }
    }
}

struct FocusImageView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @GestureState var draggingOffset: CGSize = .zero
    var body: some View {
        ZStack {
            if homeData.showImageViewer {
                Color.gray
                    .opacity(homeData.bgopacity)
                    .edgesIgnoringSafeArea(.all)
                FocusedImage(image: homeData.selectedImageID)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: {withAnimation(.default){
                homeData.showImageViewer.toggle()
            }}, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.35))
                    .clipShape(Circle())
            })
            .padding(10)
            .opacity(homeData.showImageViewer ? homeData.bgopacity : 0)
            , alignment: .topTrailing)
        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _) in
            outValue = value.translation
            homeData.onChange(value: draggingOffset)
        }).onEnded(homeData.onEnd(value:)))
    }
}
struct FocusedImage: View {
    @EnvironmentObject var homeData: HomeViewModel
    @ObservedObject var urlImageModel: UrlImageModel
    @State var scale: CGFloat = 1.0
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    @State var savedXValue: CGFloat = 0
    @State var savedYValue: CGFloat = 0
    init(image: String) {urlImageModel = UrlImageModel(urlString: image)}
    var body: some View {
        VStack {
            Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
                .resizable()
                .pinchToZoom()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

class HomeViewModel: ObservableObject {
    @Published var allImages: [String]
    @Published var showImageViewer = false
    @Published var imageViewerOffset: CGSize = .zero
    @Published var selectedImageID: String = ""
    @Published var bgopacity: Double = 1
    @Published var imageScale: CGFloat = 1
    @Published var indexPhoto: Int = 0
    init(allImages: [String]) {
        self.allImages = allImages
    }
    func onChange(value: CGSize) {
        imageViewerOffset = value
        let halgHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halgHeight
        withAnimation(.default) {
            bgopacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            if translation < 80 {
                imageViewerOffset = .zero
                bgopacity = 1
            } else {
                showImageViewer.toggle()
                imageViewerOffset = .zero
                bgopacity = 1
            }
        }
    }
    
}
