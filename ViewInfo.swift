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
    
    private static var all: [ViewInfo] {
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
    
    private static var defaults: [ViewInfo] {
        return [
            ViewInfo(name: Lets.setNumberKey, width: 10, isOn: true),
            ViewInfo(name: Lets.previousWorkoutKey, width: 25, isOn: true),
            ViewInfo(name: Lets.targetWeightKey, width: 20, isOn: true),
            ViewInfo(name: Lets.targetRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.doneButtonCompletedWeightCompletedRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.failButtonKey, width: 8, isOn: true),
            
            ViewInfo(name: Lets.noteButtonKey, width: 8, isOn: true)
        ]
    }
   
    static var usesCombinedView: Bool { return UserDefaults.standard.value(forKey: Lets.combineFailAndCompletedWeightAndRepsKey) as? Bool ?? false }
    
    static func setUsesCombinedView(_ bool: Bool) {
        UserDefaults.standard.set(bool, forKey: Lets.combineFailAndCompletedWeightAndRepsKey)
    }
    static var saved: [ViewInfo] {
        return (UserDefaults.standard.value(forKey: Lets.viewInfoKey) as? [[Any]]).map { $0.map { ViewInfo.from(array: $0) } } ?? ViewInfo.defaults
    }
    
    static var routineColumnViewInfo: [(String,CGFloat)] { return [(Lets.setNumberKey,10),(Lets.targetWeightKey,45),(Lets.targetRepsKey,45)] }
}
