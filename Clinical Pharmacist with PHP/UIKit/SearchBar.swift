//
//  SearchBar.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/18/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearchButtonChanged: (() -> Void)?
    var isFirstResponder: Bool = false
    class Coordinator: NSObject, UISearchBarDelegate {
        let searchBarView: SearchBar
        var didBecomeFirstResponder = false
        init(_ searchBar: SearchBar) {
            self.searchBarView = searchBar
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchBarView.text = searchText
            searchBarView.onSearchButtonChanged?()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBarView.onSearchButtonChanged?()
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.delegate = context.coordinator
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(searchBar.doneButtonTapped(button:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [spacer, doneButton]
        toolBar.setItems([spacer, doneButton], animated: true)
        searchBar.inputAccessoryView = toolBar
        return searchBar
    }
    
func updateUIView(_ uiView: UISearchBar, context: Context) {
    uiView.text = self.text
    if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                uiView.becomeFirstResponder()
                context.coordinator.didBecomeFirstResponder = true
            }
    }
}

extension  UISearchBar {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
    
}

