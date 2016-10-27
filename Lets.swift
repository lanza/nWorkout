import Foundation
import CoreGraphics

struct Lets {
    static let workoutDateFormat = "EEEE - MM/d/yyyy - h:mm a"
    static let workoutStartTimeFormat = "h:mm a"
    static let workoutDurationTimeFormat = "h:mm"
    static let timeZoneAbbreviation = "EST"
    
    static let liftCellNameLabelHeight: CGFloat = 25
    static let liftCellTableHeaderHeight: CGFloat = 23
    static let innerTableHeaderViewHeight: CGFloat = Lets.liftCellNameLabelHeight + Lets.liftCellTableHeaderHeight + 16
    static let subTVCellSize: CGFloat = 32
    
    static let newWorkoutBarButtonText = "New Workout"
    static let newLiftBarButtonText = "New Lift"
    static let addSetText = "Add set..."
    static let finishWorkout = "Finish Workout"
    
    static let keyboardToViewRatio = 0.4
    
    static let buffer: CGFloat = 8.0
    
    static let selectWorkoutBatchSize = 20
    static let selectLiftTypeBatchSize = 20
    static let defaultBatchSize = 10
 
    static let blankWorkoutText = "Blank Workout"
    
    static let tableCellAdditionAnimationDuration = 0.3
    
    static let newLiftPlaceholderText = "Lift name..."
    
    static let workoutDateDF: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Lets.workoutDateFormat
        let locale = Locale(identifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        return formatter
    }()
    static let workoutStartTimeDF: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = Lets.workoutStartTimeFormat
        let locale = Locale(identifier: "en_US_POSIX")
        f.locale = locale
        f.timeZone = TimeZone(abbreviation: Lets.timeZoneAbbreviation)
        return f
    }()
    static let workoutDurationDF: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = Lets.workoutDurationTimeFormat
        return f
    }()
}

