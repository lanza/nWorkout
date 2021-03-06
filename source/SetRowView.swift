import UIKit

protocol SetRowViewDelegate: AnyObject {
  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NSet)
}

class SetRowView: BaseRowView {

  weak var delegate: SetRowViewDelegate!

  override func prepareForReuse() {
    super.prepareForReuse()
    set = nil
  }

  override func setupColumns() {
    super.setupColumns()
    setupButtons()
  }

  var set: NSet! {
    didSet {
      guard let set = set else { return }
      noteButton?.update(for: set)

      if set.isComplete() {
        setUI(for: .complete)
      } else if set.didFail() {
        setUI(for: .fail)
      } else if set.isFresh() {
        setUI(for: .fresh)
      }
    }
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  required init() {
    super.init()

    setupSelectedColumnViewTypesAndWidth()
    configColumnViewTypes()
    configColumnWidthPercentages()
  }

  let viewInfos = ViewInfo.saved
  var selectedColumnViewTypes: [String]!
  var selectedColumnViewWidths: [CGFloat]!

  func setupSelectedColumnViewTypesAndWidth() {
    selectedColumnViewTypes = viewInfos.filter { $0.isOn }.map { $0.name }
    selectedColumnViewWidths = viewInfos.filter { $0.isOn }.map { $0.width }
  }

  func configColumnViewTypes() {
    columnViewTypes = selectedColumnViewTypes.map { dict[$0]! }
  }

  func configColumnWidthPercentages() {
    let sum = selectedColumnViewWidths.reduce(0, +)
    columnWidths = selectedColumnViewWidths.map { ($0 * 100) / sum }
  }

  let usesCombinedView = ViewInfo.usesCombinedView

  var didFail = false
  var isComplete = false
  var isFresh = false

  enum State {
    case fail
    case fresh
    case complete
  }

  func computeState() -> State {
    if set.reps == set.completedReps && set.weight == set.completedWeight {
      return .complete
    } else if set.reps > set.completedReps || set.weight > set.completedWeight {
      return .fail
    } else if set.completedReps == 0 || set.completedWeight == 0 {

      // TODO: this is also the condition for failed and skipped... figure out
      // how to properly represent this...
      return .fresh
    }
    fatalError()
  }

  func setUI(for state: State) {

    switch state {
    case .fail:
      failButton?.setFail(true)
      completeButton?.setComplete(false)

      isComplete = false
      isFresh = false
      didFail = true

      completedWeightTextField?.setNumber(double: set.weight)
      completedRepsTextField?.setNumber(int: 0)

      if usesCombinedView {
        completedWeightTextField?.isHidden = false
        completedRepsTextField?.isHidden = false
        completeButton?.setHide(true)
      }
    case .complete:
      failButton?.setFail(false)
      completeButton?.setComplete(true)

      isComplete = true
      isFresh = false
      didFail = false

      completedWeightTextField?.setNumber(double: set.weight)
      completedRepsTextField?.setNumber(int: Int(set.reps))

      if usesCombinedView {
        completedWeightTextField?.isHidden = true
        completedRepsTextField?.isHidden = true
        completeButton?.setHide(false)
      }
    case .fresh:
      failButton?.setFail(false)
      completeButton?.setComplete(false)

      isComplete = false
      isFresh = true
      didFail = false

      completedWeightTextField?.setNumber(double: 0)
      completedRepsTextField?.setNumber(int: 0)

      if usesCombinedView {
        completedWeightTextField?.isHidden = true
        completedRepsTextField?.isHidden = true
        completeButton?.setHide(false)
      }
    }
  }

  func setFailed() {
    setUI(for: .fail)
    set.setCompleted(weight: set.weight, reps: 0)
    completedRepsTextField?.becomeFirstResponder()
  }

  func setComplete() {
    setUI(for: .complete)
    set.setCompleted(weight: set.weight, reps: Int(set.reps))
  }

  func setFresh() {
    setUI(for: .fresh)
    set.setCompleted(weight: 0, reps: 0)
  }

  @objc func failButtonTapped() {
    if self.didFail {
      self.setFresh()
    } else {
      self.setFailed()
    }
  }
  @objc func completeButtonTapped() {
    if self.isComplete {
      self.setFresh()
    } else {
      self.setComplete()
    }
  }
  @objc func noteButtonTapped() {
    self.delegate.setRowView(self, didTapNoteButtonForSet: self.set)
  }
  func setupButtons() {

    failButton?.addTarget(
      self, action: #selector(failButtonTapped), for: .touchUpInside)
    completeButton?.addTarget(
      self, action: #selector(completeButtonTapped), for: .touchUpInside)
    noteButton?.addTarget(
      self, action: #selector(noteButtonTapped), for: .touchUpInside)
  }

  let dict: [String: UIView.Type] = [
    Lets.setNumberKey: SetNumberLabel.self,
    Lets.previousWorkoutKey: WeightAndRepsLabelHolder.self,
    Lets.targetWeightKey: WeightAndRepsTextField.self,
    Lets.targetRepsKey: WeightAndRepsTextField.self,
    Lets.completedWeightKey: CompletedWeightAndRepsTextField.self,
    Lets.completedRepsKey: CompletedWeightAndRepsTextField.self,
    "Timer": UILabel.self,
    Lets.noteButtonKey: NoteButton.self,
    Lets.doneButtonKey: CompleteButton.self,
    Lets.failButtonKey: FailButton.self,
    Lets.doneButtonCompletedWeightCompletedRepsKey: CombinedView.self,
  ]

  var combinedView: CombinedView? {
    guard usesCombinedView else { return nil }
    guard
      let index = selectedColumnViewTypes.firstIndex(
        of: Lets.doneButtonCompletedWeightCompletedRepsKey
      )
    else { return nil }
    guard let cv = columnViews[index] as? CombinedView else { fatalError() }
    return cv
  }

  var previousLabel: WeightAndRepsLabelHolder? {
    guard
      let index = selectedColumnViewTypes.firstIndex(
        of: Lets.previousWorkoutKey)
    else { return nil }
    guard let pl = columnViews[index] as? WeightAndRepsLabelHolder else {
      fatalError()
    }
    return pl
  }

  var setNumberLabel: SetNumberLabel? {
    guard let index = selectedColumnViewTypes.firstIndex(of: Lets.setNumberKey)
    else { return nil }
    guard let snl = columnViews[index] as? SetNumberLabel else { fatalError() }
    return snl
  }

  var targetWeightTextField: WeightAndRepsTextField? {
    guard
      let index = selectedColumnViewTypes.firstIndex(of: Lets.targetWeightKey)
    else { return nil }
    guard let twtf = columnViews[index] as? WeightAndRepsTextField else {
      fatalError()
    }
    return twtf
  }

  var targetRepsTextField: WeightAndRepsTextField? {
    guard let index = selectedColumnViewTypes.firstIndex(of: Lets.targetRepsKey)
    else { return nil }
    guard let trtf = columnViews[index] as? WeightAndRepsTextField else {
      fatalError()
    }
    return trtf
  }

  var completedWeightTextField: CompletedWeightAndRepsTextField? {
    if let cv = combinedView {
      return cv.completedWeightTextField
    }
    guard
      let index = selectedColumnViewTypes.firstIndex(
        of: Lets.completedWeightKey)
    else { return nil }
    guard let cwtf = columnViews[index] as? CompletedWeightAndRepsTextField
    else { fatalError() }
    return cwtf
  }

  var completedRepsTextField: CompletedWeightAndRepsTextField? {
    if let cv = combinedView {
      return cv.completedRepsTextField
    }
    guard
      let index = selectedColumnViewTypes.firstIndex(of: Lets.completedRepsKey)
    else { return nil }
    guard let crtf = columnViews[index] as? CompletedWeightAndRepsTextField
    else { fatalError() }
    return crtf
  }

  var completeButton: CompleteButton? {
    if let cv = combinedView {
      return cv.completeButton
    }
    guard let index = selectedColumnViewTypes.firstIndex(of: Lets.doneButtonKey)
    else { return nil }
    guard let cb = columnViews[index] as? CompleteButton else { fatalError() }
    return cb
  }

  var failButton: FailButton? {
    guard let index = selectedColumnViewTypes.firstIndex(of: Lets.failButtonKey)
    else { return nil }
    guard let fb = columnViews[index] as? FailButton else { fatalError() }
    return fb
  }

  var noteButton: NoteButton? {
    guard let index = selectedColumnViewTypes.firstIndex(of: Lets.noteButtonKey)
    else { return nil }
    guard let nb = columnViews[index] as? NoteButton else { fatalError() }
    return nb
  }
}
