import Foundation
import CoreGraphics

struct Lets {
    
    //MARK: Functionality strings
    static let chartViewWillDeleteNotificationName = "chartViewWillDelete"
    static let chartViewDidDeleteNotificationName = "chartViewDidDelete"
    
    //MARK: UserDefaultsKeys
    static let liftTypesKey = "liftTypes"
    
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
    static let createNewRoutine = "Create new Routine"
    static let addNewLiftType = "Add new lift type"
    static func deleteConfirmationFor(name: String) -> (title: String, message: String) {
        return (title: "Delete \(name)", message: "Are you sure you want to delete this \(name)?")
    }
    static let startBlankWorkout = "Start Blank Workout"
    static let addLift = "Add Lift"
    static let cancelWorkout = "Cancel Workout"
    static let finishWorkout = "Finish Workout"
    static let viewWorkoutDetails = "View Workout Details"
    
    static let show = "Show"
    static let blank = "Blank"
    static let workout = "Workout"
    static let routine = "Routine"
    static let new = "New"
    static let noteButtonText = "Note"
    
    static let done = "Done"
    static let cancel = "Cancel"
    static let yes = "Yes"
    static let no = "No"
    
    static let newLift = "New Lift"
    static let noPreviousSet = "No previous set"
    
    static let failButtonText = "Fail"
    
    //MARK: ViewInfo stuff
    static let setNumberKey = "Set Number"
    static let targetWeightKey = "Target Weight"
    static let targetRepsKey = "Target Reps"
    static let completedWeightKey = "Completed Weight"
    static let completedRepsKey = "Completed Reps"
    static let doneButtonKey = "Done Button"
    static let previousWorkoutKey = "Previous Workout"
    static let failButtonKey = "Fail Button"
    
    static let timerKey = "Timer"
    static let noteButtonKey = "Note"
    
    static let doneButtonCompletedWeightCompletedRepsKey = "Done Button/Completed Weight/Completed Reps"
    static let combineFailAndCompletedWeightAndRepsKey = "CombineFailAndCompletedWeightAndReps"
    
    static let viewInfoKey = "View Info"
    
    //MARK: DateFormatters
    static let workoutDateFormat = "EEEE - MM/d/yyyy - h:mm a"
    static let workoutStartTimeFormat = "h:mm a"
    //    static let workoutDurationTimeFormat = "h:mm"
    static let timeZoneAbbreviation = "EST"
    
    
    
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
    
    //MARK: Other constants
    static let keyboardToViewRatio = 0.4
}
