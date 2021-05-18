import SwiftUI

struct ChartData {
  var label: String
  var value: Double
}

let chartDataSet = [
  ChartData(label: "January 2021", value: 340.32),
  ChartData(label: "February 2021", value: 250.0),
  ChartData(label: "March 2021", value: 430.22),
  ChartData(label: "April 2021", value: 350.0),
  ChartData(label: "May 2021", value: 450.0),
  ChartData(label: "June 2021", value: 380.0),
  ChartData(label: "July 2021", value: 365.98),
]

func normalizedValue(index: Int, data: [ChartData]) -> Double {
  var allValues: [Double] {
    var values: [Double] = []
    for d in data {
      values.append(d.value)
    }
    return values
  }
  guard let max = allValues.max() else { return 1 }
  if max != 0 {
    return Double(data[index].value) / Double(max)
  } else {
    return 1
  }
}

struct BarChart: View {
  var title: String
  var legend: String
  var barColor: Color
  var data: [ChartData]

  @State private var currentValue = ""
  @State private var currentLabel = ""
  @State private var touchLocation: CGFloat? = nil

  func barIsTouched(index: Int) -> Bool {
    guard let tl = touchLocation else { return false }
    let i = CGFloat(index)
    let c = CGFloat(data.count)
    return tl > (i / c) && tl < ((i + 1) / c)
  }
  func updateCurrentValue() {
    let index = Int(touchLocation! * CGFloat(data.count))
    guard index < data.count && index >= 0 else {
      currentValue = ""
      currentLabel = ""
      return
    }
    currentValue = "\(data[index].value)"
    currentLabel = data[index].label
  }

  fileprivate func resetValues() {
    touchLocation = -1
    currentValue = ""
    currentLabel = ""
  }

  func labelOffset(in width: CGFloat) -> CGFloat {
    let currentIndex = Int(touchLocation! * CGFloat(data.count))
    guard currentIndex < data.count && currentIndex >= 0 else { return 0 }
    let cellWidth = width / CGFloat(data.count)
    let actualWidth = width - cellWidth
    let position = cellWidth * CGFloat(currentIndex) - actualWidth / 2
    return position
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .bold()
        .font(.largeTitle)
      Text("Current value: \(currentValue)")
        .font(.headline)
      GeometryReader { geometry in
        VStack {
          HStack {
            ForEach(0..<data.count, id: \.self) { i in
              BarChartCell(
                value: normalizedValue(index: i, data: data), barColor: barColor
              )
              .opacity(barIsTouched(index: i) ? 1 : 0.7)
              .scaleEffect(
                barIsTouched(index: i)
                  ? CGSize(width: 1.05, height: 1)
                  : CGSize(width: 1, height: 1), anchor: .bottom
              )
              .animation(.spring())
              .padding(.top)
            }
          }
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged({ position in
                let touchPosition =
                  position.location.x / geometry.frame(in: .local).width
                touchLocation = touchPosition
                updateCurrentValue()
              })
              .onEnded({ position in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  withAnimation(Animation.easeOut(duration: 0.5)) {
                    resetValues()
                  }
                }
              })
          )

          if currentLabel.isEmpty {
            Text(legend)
              .bold()
              .foregroundColor(.black)
              .padding(5)
              .background(
                RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
                  .shadow(radius: 3))
          } else {
            Text(currentLabel)
              .bold()
              .foregroundColor(.black)
              .padding(5)
              .background(
                RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
                  .shadow(radius: 3)
              )
              .animation(.easeIn)
              .offset(x: labelOffset(in: geometry.frame(in: .local).width))
              .animation(.easeIn)
          }
        }
      }
    }
    .padding()
  }
}

struct BarChart_Previews: PreviewProvider {
  static var previews: some View {
    BarChart(
      title: "Monthly Sales", legend: "EUR", barColor: .blue, data: chartDataSet
    )
  }
}
