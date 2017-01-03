import Foundation

class RoutineSetRowView: SetRowView {
    override func setupSelectedColumnViewTypesAndWidth() {
        selectedColumnViewTypes = [Lets.setNumberKey,Lets.targetWeightKey,Lets.targetRepsKey]
        selectedColumnViewWidths = [10,45,45]
    }
}
