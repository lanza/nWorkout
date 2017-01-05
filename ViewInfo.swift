import UIKit

struct ViewInfo: Equatable {
    static func ==(lhs: ViewInfo, rhs: ViewInfo) -> Bool {
        return lhs.name == rhs.name
    }
    var name: String
    var width: CGFloat
    var isOn: Bool
    
    static func from(array: [Any]) -> ViewInfo {
        return ViewInfo(name: array[0] as! String, width: array[1] as! CGFloat, isOn: array[2] as! Bool)
    }
    var array: [Any] {
        return [name,width,isOn]
    }
    
    static var all: [ViewInfo] {
        return [
            ViewInfo(name: Lets.setNumberKey, width: 10, isOn: true),
            ViewInfo(name: Lets.previousWorkoutKey, width: 25, isOn: true),
            ViewInfo(name: Lets.targetWeightKey, width: 20, isOn: true),
            ViewInfo(name: Lets.targetRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.completedWeightKey, width: 20, isOn: true),
            ViewInfo(name: Lets.completedRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.doneButtonKey, width: 20, isOn: true),
            ViewInfo(name: Lets.failButtonKey, width: 8, isOn: true),
            
            ViewInfo(name: Lets.noteButtonKey, width: 8, isOn: true)
        ]
    }
}
