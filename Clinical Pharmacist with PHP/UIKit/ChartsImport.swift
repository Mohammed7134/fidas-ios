//
//  ChartsImport.swift
//  Cinical Pharmacist
//
//  Created by Mohammed Almutawa on 11/12/20.
//  Copyright © 2020 Mohammed Almutawa. All rights reserved.
//
import Charts
import SwiftUI
class Object {
    var timeCreated : Date = Date()
    var value : Double = 0.0
    init(time: Date, value: Double) {
        self.timeCreated = time
        self.value = value
    }
}
//public class DateValueFormatter: NSObject, AxisValueFormatter {
//    private let dateFormatter = DateFormatter()
//    private let objects:[Object]
//
//    init(objects: [Object]) {
//        self.objects = objects
//        super.init()
//        dateFormatter.dateFormat = "dd MMM HH:mm"
//    }
//
//    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        if value >= 0 && value < Double(objects.count){
//            let object = objects[Int(value)]
//            return dateFormatter.string(from: object.timeCreated)
//        }
//        return ""
//    }
//}
public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
struct LineChart: UIViewRepresentable {
    
    var values: [OptionalFlexDouble]?
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        
        let yAxis = chartView.rightAxis
        yAxis.setLabelCount(5, force: true)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = true
        yAxis.drawAxisLineEnabled = true

        let xAxis = chartView.xAxis
        xAxis.labelTextColor = .black
        xAxis.setLabelCount(4, force: true)
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.valueFormatter = DateValueFormatter()
        
        chartView.isUserInteractionEnabled = false
        chartView.rightAxis.enabled = true
        chartView.legend.enabled = true
        chartView.chartDescription.enabled = true
        chartView.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 0)

        
        chartView.data = addData()
        
        return chartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        uiView.data = addData()
    }
    func addData() -> LineChartData{
        if values != nil  {
            let valuesA = values!.sorted().toDoubles()
            let datePointsA = values!.sorted().toInts()
                    
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0 ..< values!.count {
                if valuesA[i] != nil {
                    let dataEntry = ChartDataEntry(x: Double(datePointsA[i]), y: valuesA[i]!)
                    dataEntries.append(dataEntry)
                }
            }

            let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")

            lineChartDataSet.mode = .cubicBezier
            lineChartDataSet.drawCirclesEnabled = true
            lineChartDataSet.lineWidth = 2.8
            lineChartDataSet.circleRadius = 4
            lineChartDataSet.circleHoleRadius = 3.8
            lineChartDataSet.setCircleColor(.systemBlue)
            lineChartDataSet.circleHoleColor = .systemBlue

            lineChartDataSet.drawFilledEnabled = true
            lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
            
            let lineChartData = LineChartData(dataSet: lineChartDataSet)

            lineChartData.setDrawValues(false)
            return lineChartData
        } else {
            return LineChartData(dataSet: LineChartDataSet(entries: [ChartDataEntry(x: 0, y: 0)], label: ""))
        }
    }
}

//struct LineChart_Previews: PreviewProvider {
//    static var previews: some View {
//        LineChart(values: [0, 1, 2], datePoints: [Int(Date(timeIntervalSince1970: 300000001).timeIntervalSince1970), Int(Date(timeIntervalSince1970: 300000002).timeIntervalSince1970), Int(Date(timeInterval: 300000000, since: Date()).timeIntervalSince1970)])
//    }
//}
