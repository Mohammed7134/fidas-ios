////
////  SwiftUIView.swift
////  Clinical Pharmacist with PHP
////
////  Created by Mohammed Almutawa on 4/16/21.
////
//
import SwiftUI

struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

//import SwiftUI
//import Combine
//import PDFKit
//class VM: ObservableObject {
//    @Published var medicines: [MedicineLocations] = []
//    @Published var showAlert = false
//    @Published var searchText = ""
//    @Published var hospital: Hospital = .Farwaniya
//    @Published var pharmacy: String = "Injection Store"
//    @Published var msg: String = ""
//    @Published var code : String = ""
//    @Published var list : [Details] = [] {didSet{getComps()}}
//    @Published var companies : [String] = []
//    var alertTitle = ""
//    var alertMessage = ""
//    var locationSubscriber: AnyCancellable?
//    var searchTextSubscriber: AnyCancellable?
//    var findMed: AnyCancellable?
//    init() {
//        self.searchTextSubscriber = $searchText
//            .debounce(for: 0.8, scheduler: RunLoop.main)
//            .sink {if !$0.trimmingCharacters(in: .whitespaces).isEmpty {self.getLocation(medicine: $0)}}
//        self.findMedicine()
//        //getPosts(onSuccess: {self.msg = $0})
//    }
//    func getLocation(medicine: String) {
//        self.locationSubscriber = Api.Medicine.getLocation(hospital: hospital.tbName(), pharmacy: pharmacy, medicine: medicine)
//            .catch{ _ in Just(LoadMedicinesLocationsResponse(error: true, message: "Networking error", medicines: []))}
//            .map {$0.error ? self.onError($0.message!) : $0.medicines! }
//            .assign(to: \.medicines, on: self)
//    }
//    func onError(_ err: String) -> [MedicineLocations] {
//        self.alertTitle = ERROR_TITLE
//        self.alertMessage = err
//        self.showAlert = true
//        return []
//    }
//    func findMedicine() {
//        self.findMed = Nw.findMed(name: searchText)
//            .catch{ _ in Just(DailyMedResponse(data: []))}
//            .map {$0.data}
//            .assign(to: \.list, on: self)
//    }
//    func getComps() {
//        var companyList = [String]()
//        for name in list {
//            if let startIndex = name.title.firstIndex(of: "[") {
//                if let endIndex = name.title.firstIndex(of: "]") {
//                    let company = name.title[name.title.index(after: startIndex)..<endIndex]
//                    if !companyList.contains(String(company)) {
//                        companyList.append(String(company))
//                    }
//                }
//            }
//        }
//        self.companies = companyList
//    }
//}
//struct ContentView: View {
//    @ObservedObject var vm = VM()
//    var body: some View {
//        NavigationView {
//        VStack {
//            TextField("search medicine", text: $vm.searchText, onCommit: {vm.findMedicine()})
//                .modifier(SearchFieldModifier())
//            if vm.msg.isEmpty {
//                List {
//                    ForEach(vm.companies, id:\.self) { comp in
//                        NavigationLink(comp, destination:
//                                        List {
////                                            ForEach(vm.list.filter({drug in drug.title.contains(comp)})[0], id:\.setid) {
//                                                NavigationLink(vm.list.filter({drug in drug.title.contains(comp)})[0].title, destination: PDFKitView(url: URL(string: "https://dailymed.nlm.nih.gov/dailymed/downloadpdffile.cfm?setId=\(vm.list.filter({drug in drug.title.contains(comp)})[0].setid)")!))
//                                            }
////                                        }
//                                       )
//                                        
//                    }
//                }
//                
//            } else {
//                List{
//                    Text(vm.msg)
//                }
//            }
//        }
//        .alert(isPresented: $vm.showAlert) {
//            Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text(OK)))
//        }
//        }
//    }
//}
//
//
//class XMLNode {
//    let tag: String
//    var data: String
//    let attributes: [String: String]
//    var childNodes: [XMLNode]
//    
//    init(tag: String, data: String, attributes: [String: String], childNodes: [XMLNode]) {
//        self.tag = tag
//        self.data = data
//        self.attributes = attributes
//        self.childNodes = childNodes
//    }
//    
//    func getAttribute(_ name: String) -> String? {
//        attributes[name]
//    }
//    
//    func getElementsByTagName(_ name: String) -> [XMLNode] {
//        var results = [XMLNode]()
//        
//        for node in childNodes {
//            if node.tag == name {
//                results.append(node)
//            }
//            
//            results += node.getElementsByTagName(name)
//        }
//        
//        return results
//    }
//}
//
//class MicroDOM: NSObject, XMLParserDelegate {
//    private let parser: XMLParser
//    private var stack = [XMLNode]()
//    private var tree: XMLNode?
//    
//    init(data: Data) {
//        parser = XMLParser(data: data)
//        super.init()
//        parser.delegate = self
//    }
//    
//    func parse() -> XMLNode? {
//        parser.parse()
//        
//        guard parser.parserError == nil else {
//            return nil
//        }
//        
//        return tree
//    }
//    
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
//        let node = XMLNode(tag: elementName, data: "", attributes: attributeDict, childNodes: [])
//        stack.append(node)
//    }
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        let lastElement = stack.removeLast()
//        
//        if let last = stack.last {
//            last.childNodes += [lastElement]
//        } else {
//            tree = lastElement
//        }
//    }
//    
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        stack.last?.data = string
//    }
//}
//
//
//struct Response: Decodable {
//    var myData: String
//}
//extension String {
//    func readPDF() -> String
//    {
//        let path = "\(self)"
//        let url = URL(string: path)!
//        let pdf = PDFDocument(url: url)
//        return pdf!.string!
//    }
//}
//struct DailyMedResponse: Codable {
//    var data: [Details]
//}
//
//struct Result: Codable {
//    var data: [Details]
//}
//struct Details: Codable {
//    var setid: String
//    var title: String
//}
//class Nw {
//    static func findMed(name: String) -> AnyPublisher<DailyMedResponse, Error> {
//        let request = NSMutableURLRequest(url: NSURL(string: "https://dailymed.nlm.nih.gov/dailymed/services/v2/spls.json?drug_name=\(name)")! as URL)
//        request.httpMethod = "GET"
//        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
//            .map{
//                let responseString = NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)
//                let str = String(describing: responseString!)
//                print(str)
//                return $0.data
//            }
//            .decode(type: DailyMedResponse.self, decoder: JSONDecoder())
//            .print()
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//    static func findMedSpl(code: String) -> AnyPublisher<DailyMedResponse, Error> {
//        let request = NSMutableURLRequest(url: NSURL(string: "https://dailymed.nlm.nih.gov/dailymed/downloadzipfile.cfm?setId=1efe378e-fee1-4ae9-8ea5-0fe2265fe2d8")! as URL)
//        request.httpMethod = "GET"
//        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
//            .map{
//                let responseString = NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)
//                let str = String(describing: responseString!)
//                print(str)
//                return $0.data
//            }
//            .decode(type: DailyMedResponse.self, decoder: JSONDecoder())
//            .print()
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//    static func getpdf() {
////        if let pdf = PDFDocument(url: URL(string:
//        let page = PDFDocument(url: URL(string: "https://www.w3.org/WAI/WCAG20/Techniques/working-examples/PDF20/table.pdf")!)
////        page1.
////        let page = "https://www.w3.org/WAI/WCAG20/Techniques/working-examples/PDF20/table.pdf".readPDF()
////            let pageCount = pdf.pageCount
////            let documentContent = NSMutableAttributedString()
////
////            for i in 1 ..< pageCount {
////                guard let page = pdf.page(at: i) else { continue }
////                guard let pageContent = page.attributedString else { continue }
////                print(pageContent)
////                documentContent.append(page.attributedString)
////            }
//        let charIndex = page?.page(at: 0)?.characterIndex(at: CGPoint(x: 72.0, y: 679.725)) ?? 0
//
//        let characterBounds = page?.page(at: 0)?.characterBounds(at: 0)
//        let selectionPoint = CGPoint(x: 5, y: 5)
//
//        // Returns the selection for only the word the character is a part of.
//        let wordSelection = page?.page(at: 0)?.selectionForWord(at: selectionPoint)
//
//        // Returns the `PDFSelection` for the entire line based on the point in the coordinate space provided.
//        let lineSelection = page?.page(at: 0)?.selectionForLine(at: selectionPoint)
//
//        let anotherSelectionPoint = CGPoint(x: 72.0 + 100, y: 679.725)
//
//        // Will create a selection using only the characters occurring between the points given.
//        let precisionSelection = page?.page(at: 0)?.selection(from: CGPoint(x: 72.0, y: 679.725), to: anotherSelectionPoint)
//        
//        // Creates a selection based on the range for the characters provided.
//        let rangeSelection = page?.page(at: 0)?.selection(for: NSRange(location: 0, length: 15))
//        
//
//        let precisionSelection1 = page?.page(at: 0)?.selection(from: CGPoint(x: 1, y: 695), to: CGPoint(x: 170, y: 695))
//        if precisionSelection1?.string != nil {
//            print(precisionSelection1?.attributedString?.string)
//        }
//
//        let precisionSelection2 = page?.page(at: 0)?.selection(from: CGPoint(x: 1, y: 675), to: CGPoint(x: 300, y: 675))
//        if precisionSelection2?.string != nil {
//            print(precisionSelection2?.attributedString?.string)
//        }
//    }
//    static func getPosts(onSuccess: @escaping (_ str: String) -> Void) {
//        let url = "https://dailymed.nlm.nih.gov/dailymed/services/v2/spls/1efe378e-fee1-4ae9-8ea5-0fe2265fe2d8.xml"
//        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//            let res = try? JSONDecoder().decode(Response.self, from: data!)
//            if let response = res {
//                DispatchQueue.main.async {
//                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                    let str = String(describing: responseString)
//                    let string = str
//                    let dom = MicroDOM(data: Data(string.utf8))
//                    let tree = dom.parse()
//                    print(tree?.tag ?? "")
//                    
//                    if let tags = tree?.getElementsByTagName("component") {
//                        for tag in tags {
//                            print("MyTag", tag)
//                            let structuredBodyTags = tag.getElementsByTagName("structuredBody")
//                            for componentTag in structuredBodyTags[2].childNodes {
//                                print("hello2")
//                                for sectionTag in componentTag.childNodes {
//                                    print("hello3")
//                                    for detailTag in sectionTag.childNodes {
//                                        print(detailTag.data, "hello4")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            } else {
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                let str = String(describing: responseString!)
//                DispatchQueue.main.async {
//                    var testStr = str
//                    var finalString = ""
//                    while true {
//                        if let titleRangeStart = testStr.range(of: "<title>") {
//                            guard let titleRangeEnd = testStr.range(of: "</title>")  else {break}
//                            let title = String(testStr[titleRangeStart.upperBound..<titleRangeEnd.lowerBound]).htmlToString +  "\n"
//                            finalString.append(title)
//                            testStr = String(testStr[titleRangeEnd.upperBound...])
//                            
//                            if let sectionRangeEnd = testStr.range(of: "</section>") {
//                                let paragraphs = String(testStr[..<sectionRangeEnd.lowerBound]).htmlToString
//                                finalString.append(paragraphs)
//                                testStr = String(testStr[sectionRangeEnd.upperBound...])
//                            }
//                        } else {
//                            break
//                        }
//                    }
//                    onSuccess(finalString)
////                    let string = str
////                    let dom = MicroDOM(data: Data(string.utf8))
////                    let tree = dom.parse()
////                    print(tree?.tag ?? "")
////                    let range = string.range(of: "ID_b531f8e0-2582-4dba-b396-5c2b1c240fea")
////                    print(string[range!.upperBound]...string[range!.upperBound])
////                    if let tags = tree?.getElementsByTagName("component") {
////                        let structuredBodyTag = tags[0].getElementsByTagName("structuredBody")[0]
////                        for componentTag in structuredBodyTag.childNodes {
////                            for sectionTag in componentTag.childNodes {
////                                let sectionId = sectionTag.getAttribute("ID")
////                                if sectionId?.prefix(2) == "ID" {
////                                    print(sectionId!)
////                                }
////                                for detailTag in sectionTag.childNodes {
////                                    if detailTag.data.trimmingCharacters(in: .whitespaces).count > 1 {
////                                        print(detailTag.data.trimmingCharacters(in: .whitespaces))
////                                    }
////                                    let paragraphs = detailTag.getElementsByTagName("paragraph")
////                                    for paragraph in paragraphs {
//////                                        if paragraph.data.trimmingCharacters(in: .whitespaces).count > 1 {
////                                        paragraph.childNodes.forEach{$0.getElementsByTagName("sub").forEach{_ in print("$0.data")}}
//////                                        }
////                                    }
////                                }
////                            }
////                        }
////                    }
//                }
//            }
//        }
//        task.resume()
//    }
//}
//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return nil
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}
//
//struct PDFKitRepresentedView: UIViewRepresentable {
//    let url: URL
//
//    init(_ url: URL) {
//        self.url = url
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
//        // Create a `PDFView` and set its `PDFDocument`.
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(url: self.url)
//        return pdfView
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
//        // Update the view.
//    }
//}
//struct PDFKitView: View {
//    var url: URL
//
//    var body: some View {
//        PDFKitRepresentedView(url)
//    }
//}
//
//struct ContentView1: View {
//    let documentURL = Bundle.main.url(forResource: "PSPDFKit 9 QuickStart Guide", withExtension: "pdf")!
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("PSPDFKit SwiftUI")
//                .font(.largeTitle)
//            HStack(alignment: .top) {
//                Text("Made with ❤ at WWDC19")
//                    .font(.title)
//            }
//            PDFKitView(url: documentURL)
//        }
//    }
//}
