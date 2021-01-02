import UIKit

class TextFieldBehaviorHandler: KeyboardDelegate {
  //    var liftCells = [LiftCell]()

  var currentlyEditingLiftCell: LiftCell?

  var currentlyEditingRowView: SetRowView?
  var currentlyEditingTextField: UITextField?

  func setupSetConnections(for cell: LiftCell) {
    for setRowView in cell.rowViews {
      setupRowConnections(for: setRowView, cell: cell)
    }
  }

  func setupRowConnections(for setRowView: SetRowView, cell: LiftCell) {
    setupMapFromTextFieldsToSetRowView(for: setRowView, and: cell)
    setupObserversForTextHandlingAndCurrentlyEditing(
      setRowView: setRowView, cell: cell)
    setupObserversForUpdatingSetValuesAndSettingBackTextAfterEditing(
      setRowView: setRowView)
  }

  var textFieldToSetRowViewMap: [UITextField: SetRowView] = [:]
  var textFieldToCellMap: [UITextField: LiftCell] = [:]

  func setupMapFromTextFieldsToSetRowView(
    for setRowView: SetRowView, and cell: LiftCell
  ) {
    textFieldToSetRowViewMap[setRowView.targetWeightTextField!] = setRowView
    textFieldToSetRowViewMap[setRowView.targetRepsTextField!] = setRowView

    if let cwtf = setRowView.completedWeightTextField {
      textFieldToSetRowViewMap[cwtf] = setRowView
      textFieldToCellMap[cwtf] = cell
    }
    if let crtf = setRowView.completedRepsTextField {
      textFieldToSetRowViewMap[crtf] = setRowView
      textFieldToCellMap[crtf] = cell
    }

    textFieldToCellMap[setRowView.targetWeightTextField!] = cell
    textFieldToCellMap[setRowView.targetRepsTextField!] = cell
  }

  @objc func targetWeightTextFieldEditingDidEnd(textField: UITextField) {
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }

    if setRowView.targetWeightTextField?.text == "" {
      setRowView.targetWeightTextField?.text =
        setRowView
        .targetWeightTextField?.placeholder
    } else {
      guard let value = Double(setRowView.targetWeightTextField!.text!),
        value != setRowView.set.weight
      else { return }
      let set = setRowView.set
      set!.weight = value
      if setRowView.isComplete {
        set!.completedWeight = value
      }
    }
  }

  @objc func targetRepsTextFieldEditingDidEnd(textField: UITextField) {
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    if setRowView.targetRepsTextField?.text == "" {
      setRowView.targetRepsTextField?.text =
        setRowView.targetRepsTextField?
        .placeholder
    } else {
      guard let value = Int(setRowView.targetRepsTextField!.text!),
        value != setRowView.set.reps
      else { return }
      let set = setRowView.set
      set!.reps = Int64(value)
      if setRowView.isComplete {
        set!.completedReps = Int64(value)
      }
    }
  }

  @objc func completedWeightTextFieldEditingDidEnd(textField: UITextField) {
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    guard let cwtf = setRowView.completedWeightTextField else { return }
    if cwtf.text == "" {
      cwtf.text = cwtf.placeholder
    } else {
      guard let value = Double(cwtf.text!),
        value != setRowView.set.completedWeight
      else { return }
      setRowView.set.completedWeight = value
    }
  }

  @objc func completedRepsTextFieldEditingDidEnd(textField: UITextField) {
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    guard let crtf = setRowView.completedRepsTextField else { return }
    if crtf.text == "" {
      crtf.text =
        crtf.placeholder
    } else {
      guard let value = Int(crtf.text!),
        value != setRowView.set.completedReps
      else { return }
      setRowView.set.completedReps = Int64(value)
    }
  }

  func setupObserversForUpdatingSetValuesAndSettingBackTextAfterEditing(
    setRowView: SetRowView
  ) {
    setRowView.targetWeightTextField?.addTarget(
      self, action: #selector(targetWeightTextFieldEditingDidEnd(textField:)),
      for: .editingDidEnd)
    setRowView.targetRepsTextField?.addTarget(
      self, action: #selector(targetRepsTextFieldEditingDidEnd(textField:)),
      for: .editingDidEnd)
    setRowView.completedWeightTextField?.addTarget(
      self,
      action: #selector(completedWeightTextFieldEditingDidEnd(textField:)),
      for: .editingDidEnd)
    setRowView.completedRepsTextField?.addTarget(
      self, action: #selector(completedRepsTextFieldEditingDidEnd(textField:)),
      for: .editingDidEnd)
  }

  @objc func targetWeightTextFieldEditingDidBegin(textField: UITextField) {
    guard let cell = textFieldToCellMap[textField] else { fatalError() }
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    self.currentlyEditingLiftCell = cell
    self.currentlyEditingRowView = setRowView
    self.currentlyEditingTextField = setRowView.targetWeightTextField

    guard textField.text != nil else { return }
    textField.placeholder = textField.text
    textField.text = nil
  }

  @objc func targetRepsTextFieldEditingDidBegin(textField: UITextField) {
    guard let cell = textFieldToCellMap[textField] else { fatalError() }
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    self.currentlyEditingLiftCell = cell
    self.currentlyEditingRowView = setRowView
    self.currentlyEditingTextField = setRowView.targetRepsTextField

    guard textField.text != nil else { return }
    textField.placeholder = textField.text
    textField.text = nil
  }

  @objc func completedWeightTextFieldEditingDidBegin(textField: UITextField) {
    guard let cell = textFieldToCellMap[textField] else { fatalError() }
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    self.currentlyEditingLiftCell = cell
    self.currentlyEditingRowView = setRowView
    self.currentlyEditingTextField = setRowView.completedWeightTextField

    guard textField.text != nil else { return }
    textField.placeholder = textField.text
    textField.text = nil
  }

  @objc func completedRepsTextFieldEditingDidBegin(textField: UITextField) {
    guard let cell = textFieldToCellMap[textField] else { fatalError() }
    guard let setRowView = textFieldToSetRowViewMap[textField] else {
      fatalError()
    }
    self.currentlyEditingLiftCell = cell
    self.currentlyEditingRowView = setRowView
    self.currentlyEditingTextField = setRowView.completedRepsTextField

    guard textField.text != nil else { return }
    textField.placeholder = textField.text
    textField.text = nil
  }

  func setupObserversForTextHandlingAndCurrentlyEditing(
    setRowView: SetRowView, cell: LiftCell
  ) {
    setRowView.targetWeightTextField?.addTarget(
      self, action: #selector(targetWeightTextFieldEditingDidBegin(textField:)),
      for: .editingDidBegin)
    setRowView.targetRepsTextField?.addTarget(
      self, action: #selector(targetRepsTextFieldEditingDidBegin(textField:)),
      for: .editingDidBegin)
    setRowView.completedWeightTextField?.addTarget(
      self,
      action: #selector(completedWeightTextFieldEditingDidBegin(textField:)),
      for: .editingDidBegin)
    setRowView.completedRepsTextField?.addTarget(
      self,
      action: #selector(completedRepsTextFieldEditingDidBegin(textField:)),
      for: .editingDidBegin)
  }

  func hideWasTapped() {
    UIResponder.currentFirstResponder?.resignFirstResponder()
  }

  var liftNeedsNewSet: (() -> Void)!

  func getNeighborTextField(for textField: UITextField) -> UITextField? {
    guard let cerv = currentlyEditingRowView else { fatalError() }
    if textField === cerv.targetWeightTextField {
      if let trtf = cerv.targetRepsTextField, trtf.isHidden == false {
        return trtf
      } else if let cwtf = cerv.completedWeightTextField, cwtf.isHidden == false
      {
        return cwtf
      } else if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
        return crtf
      } else {
        return nil
      }
    } else if textField === cerv.targetRepsTextField {
      if let cwtf = cerv.completedWeightTextField, cwtf.isHidden == false {
        return cwtf
      } else if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
        return crtf
      } else {
        return nil
      }
    } else if textField === cerv.completedWeightTextField {
      if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
        return crtf
      } else {
        return nil
      }
    } else {
      return nil
    }
  }

  func nextWasTapped() {
    guard let cetf = currentlyEditingTextField,
      var cerv = currentlyEditingRowView,
      let celc = currentlyEditingLiftCell
    else { fatalError() }

    if let neighbor = getNeighborTextField(for: cetf) {
      neighbor.becomeFirstResponder()
    } else if let rowIndex = celc.rowViews.firstIndex(of: cerv),
      celc.rowViews.count > rowIndex + 1
    {
      currentlyEditingRowView = celc.rowViews[rowIndex + 1]
      cerv = currentlyEditingRowView!
      if let twtf = cerv.targetWeightTextField {
        twtf.becomeFirstResponder()
      } else if let trtf = cerv.targetRepsTextField {
        trtf.becomeFirstResponder()
      } else if let cwtf = cerv.completedWeightTextField {
        cwtf.becomeFirstResponder()
      } else if let crtf = cerv.completedRepsTextField {
        crtf.becomeFirstResponder()
      } else {
        cetf.resignFirstResponder()
        currentlyEditingTextField = nil
        currentlyEditingRowView = nil
        currentlyEditingLiftCell = nil
      }
    } else {
      liftNeedsNewSet()
      currentlyEditingLiftCell?.rowViews.last!.targetWeightTextField?
        .becomeFirstResponder()
    }
  }

  func backspaceWasTapped() {
    currentlyEditingTextField?.deleteBackward()
  }

  func keyWasTapped(character: String) {
    currentlyEditingTextField!.text?.append(character)
  }
}
