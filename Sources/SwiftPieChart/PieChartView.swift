//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

@available(OSX 10.15, *)
public struct PieChartView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String
    
    public var colors: [Color]
    public var backgroundColor: Color
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Double], names: [String], formatter: @escaping (Double) -> String, colors: [Color] = [Color.blue, Color.green, Color.orange], backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.60){
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0..<self.values.count) { i in
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // ... (your existing code for gesture handling)
                            }
                            .onEnded { value in
                                // ... (your existing code for gesture handling)
                            }
                    )
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                        .alignmentGuide(.center) { dimensions in
                            CGPoint(x: dimensions[.midX], y: dimensions[.midY])
                        }
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.title)
                    }
                }
            }
            .background(self.backgroundColor)
            .foregroundColor(Color.white)
        }
        
    }
    
    @available(OSX 10.15, *)
    struct PieChartRows: View {
        var colors: [Color]
        var names: [String]
        var values: [String]
        var percents: [String]
        
        var body: some View {
            VStack{
                ForEach(0..<self.values.count){ i in
                    HStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(self.colors[i])
                            .frame(width: 20, height: 20)
                        Text(self.names[i])
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(self.values[i])
                            Text(self.percents[i])
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
        }
    }
    
    @available(OSX 10.15.0, *)
    struct PieChartView_Previews: PreviewProvider {
        static var previews: some View {
            PieChartView(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], formatter: {value in String(format: "$%.2f", value)})
        }
    }
}
