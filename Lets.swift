import Foundation
import CoreGraphics

struct Lets {
    
    //MARK: Main words
    static let history = "History"
    static let routines = "Routines"
    static let statistics = "Statistics"
    static let settings = "Settings"
    static let start = "Start"
    
    //MARK: Bar Button Item labels
    static let hide = "Hide"
    
    //MARK: Various labels
    static let selectWorkout = "Select Workout"
    static let show = "Show"
    
    
    static let setNumberKey = "Set Number"
    static let targetWeightKey = "Target Weight"
    static let targetRepsKey = "Target Reps"
    static let completedWeightKey = "Completed Weight"
    static let completedRepsKey = "Completed Reps"
    static let doneButtonKey = "Done Button"
    static let previousWorkoutKey = "Previous Workout"
    static let failButtonKey = "Fail Button"

    static let doneButtonCompletedWeightCompletedRepsKey = "Done Button/Completed Weight/Completed Reps"

    static let combineFailAndCompletedWeightAndRepsKey = "CombineFailAndCompletedWeightAndReps"

    static let viewInfoKey = "View Info"


    static let workoutDateFormat = "EEEE - MM/d/yyyy - h:mm a"
    static let workoutStartTimeFormat = "h:mm a"
//    static let workoutDurationTimeFormat = "h:mm"
    static let timeZoneAbbreviation = "EST"

    static let keyboardToViewRatio = 0.4

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
//    static let workoutDurationDF: DateFormatter = {
//        let f = DateFormatter()
//        f.dateFormat = Lets.workoutDurationTimeFormat
//        return f
//    }()
}
