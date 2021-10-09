//
//  Extensions.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 10/15/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//

import SwiftUI
extension Encodable {
    func toDictionary() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {print("Could not encode to dictionary");throw NSError()}
        return dictionary
    }
}
extension Decodable {
    init(fromDictionary: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: fromDictionary, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}

//extension String {
//    func splitStringToArray() -> [String] {
//        let trimmedText = String(self.filter{!" \n\t\r".contains($0)})
//        var subStringArray = [String]()
//        for (index, _) in trimmedText.enumerated() {
//            let prefixIndex = index + 1
//            let subStringPrefix = String(trimmedText.prefix(prefixIndex)).lowercased()
//            subStringArray.append(subStringPrefix)
//        }
//        return subStringArray
//    }
//}

func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) yrs ago"
    } else if (components.year! >= 1){
        if (numericDates){ return "1 yr ago"
        } else { return "Last year" }
    } else if (components.month! >= 2) {
        return "\(components.month!) ms ago"
    } else if (components.month! >= 1){
        if (numericDates){ return "1 m ago"
        } else { return "Last month" }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) wks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){ return "1 wk ago"
        } else { return "Last week" }
    } else if (components.day! >= 2) {
        return "\(components.day!) ds ago"
    } else if (components.day! >= 1){
        if (numericDates){ return "1 d ago"
        } else { return "Yesterday" }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hrs ago"
    } else if (components.hour! >= 1){
        if (numericDates){ return "1 hr ago"
        } else { return "An hour ago" }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) mins ago"
    } else if (components.minute! >= 1){
        if (numericDates){ return "1 min ago"
        } else { return "A minute ago" }
    } else if (components.second! >= 3) {
        return "\(components.second!) s ago"
    } else { return "Just now" }
}



//extension UITextView {
//    func hideSuggestions() {
//        // Removes suggestions only
//        autocorrectionType = .no
//        //Removes Undo, Redo, Copy & Paste options
//        removeUndoRedoOptions()
//    }
//}
//
//extension UITextField {
//    func hideSuggestions() {
//        // Removes suggestions only
//        autocorrectionType = .no
//        //Removes Undo, Redo, Copy & Paste options
//        removeUndoRedoOptions()
//    }
//}
//
//extension UIResponder {
//    func removeUndoRedoOptions() {
//        //Removes Undo, Redo, Copy & Paste options
//        inputAssistantItem.leadingBarButtonGroups = []
//        inputAssistantItem.trailingBarButtonGroups = []
//    }
//}

extension String {
    func StringToDoubleValue() -> Double {
        Double(self) ?? 0
    }
}

//extension Bundle {
//    func decode<T: Codable>(_ file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle.")
//        }
//
//        let decoder = JSONDecoder()
//
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle.")
//        }
//
//        return loaded
//    }
//}




extension Array where Element == OptionalFlexDouble {
    func toDoubles() -> [Double?] {
        var doubles = [Double?]()
        for f in self {
            doubles.append(f.value)
        }
        return doubles
    }
}

extension Array where Element == OptionalFlexDouble {
    func toInts() -> [Int] {
        var ints = [Int]()
        for f in self {
            ints.append(Int(f.date))
        }
        return ints
    }
}




#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension View {
    func onTapGestureInIPhone(_ action: @escaping () -> Void) -> some View {
        return modifier(CustomedOnTapGesture(action))
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

extension View {
    func customedListRowBackground() -> some View {
        return modifier(CustomedListRowBackground())
    }
}
extension View {
    public func currentDeviceNavigationViewStyle() -> AnyView {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
}



extension View {
    func customedLeadingPadding() -> some View {
        self.modifier(CustomedLeadingPadding())
    }
}


extension View {
    func navigationBarColor(color: UIColor = UIColor(hex: NAVIGATION_BAR_COLOR_HEX)!) -> some View {
        self.modifier(NavigationBarModifier(color: color))
    }
}
extension View {
    func customedBackground(color: UIColor = UIColor(hex: NAVIGATION_BAR_COLOR_HEX)!) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(self
                .modifier(CustomViewModefier())
                .modifier(NavigationBarModifier(color: color)))
        } else {
            return AnyView(self
                .modifier(CustomViewModefier()))

        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
