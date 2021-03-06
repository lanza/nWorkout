import UIKit

protocol LiftCellDelegate: AnyObject {
  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NSet)
  func liftCell(_ liftCell: LiftCell, didTapNoteButtonForLift lift: NLift)
}

extension LiftCell: ChartViewDelegate {
  func chartView(
    _ chartView: ChartView,
    commit editingStyle: ChartView.EditingStyle,
    forRowAt index: Int
  ) {
    lift.remove(at: index)
  }
}

extension LiftCell: SetRowViewDelegate {
  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NSet) {
    self.delegate.setRowView(setRowView, didTapNoteButtonForSet: set)
  }
}

class LiftCell: ChartViewCell {
  func configure(for object: NLift, at indexPath: IndexPath) {

    label.text = object.getName()

    chartView.chartViewDataSource = BaseChartViewDataSource(object: object)

    chartView.configurationClosure = { (index, rowView) in
      let rowView = rowView as! SetRowView
      rowView.delegate = self
      let set = object.object(at: index)
      rowView.set = set

      if let snl = rowView.setNumberLabel {
        snl.text = String(index + 1)
      }

      if let twtf = rowView.targetWeightTextField {
        var weight: String
        if set.weight.remainder(dividingBy: 1) == 0 {
          weight = String(Int(set.weight))
        } else {
          weight = String(set.weight)
        }
        twtf.text = weight
      }
      if let trtf = rowView.targetRepsTextField {
        trtf.text = String(set.reps)
      }

      if let cwtf = rowView.completedWeightTextField {
        cwtf.setNumber(double: set.completedWeight)
      }
      if let crtf = rowView.completedRepsTextField {
        crtf.setNumber(int: Int(set.completedReps))
      }
      if let pl = rowView.previousLabel, let prev = object.previous {
        // TODO: clean this up
        if prev.sets!.count > index {
          let set = prev.getSetsSorted()[index]
          let string = "\(set.completedReps) x \(set.completedWeight)"
          pl.text = string
        } else {
          pl.text = Lets.noPreviousSet
        }
      }
    }

    chartView.setup()
    setNeedsUpdateConstraints()
  }

  func setupContentView() {
    contentView.setBorder(color: .black, width: 1, radius: 3)

    //        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)
  }

  weak var delegate: LiftCellDelegate!

  @objc func noteButtonTapped() {
    self.delegate.liftCell(self, didTapNoteButtonForLift: self.lift)
  }

  weak var lift: NLift! {
    didSet {
      noteButton.update(for: lift)
      noteButton.addTarget(
        self, action: #selector(noteButtonTapped), for: .touchUpInside)
    }
  }

  var rowViews: [SetRowView] { return chartView.rowViews as! [SetRowView] }

  //    var setNumberLables: [UILabel?] { return rowViews.map { $0.setNumberLabel } }
  //    var weightTextFields: [UITextField?] { return rowViews.map { $0.targetWeightTextField } }
  //    var repsTextFields: [UITextField?] { return rowViews.map { $0.targetRepsTextField } }

  let label = UILabel()

  let noteButton = NoteButton()
  let addSetButton = UIButton(type: .roundedRect)

  var header: LiftTableHeaderView!

  func setHeader() {
    header = LiftTableHeaderView(type: .workout)
  }

  func setupTopContentView() {
    label.text = "Hi muffin"
    label.translatesAutoresizingMaskIntoConstraints = false
    topContentView.addSubview(label)

    noteButton.translatesAutoresizingMaskIntoConstraints = false
    noteButton.setTitle(Lets.noteButtonText)
    topContentView.addSubview(noteButton)

    setHeader()
    header.translatesAutoresizingMaskIntoConstraints = false
    topContentView.addSubview(header)

    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(equalTo: topContentView.topAnchor),
        label.leftAnchor.constraint(
          equalTo: topContentView.leftAnchor,
          constant: 4
        ),

        noteButton.topAnchor.constraint(equalTo: topContentView.topAnchor),
        noteButton.rightAnchor.constraint(
          equalTo: topContentView.rightAnchor,
          constant: -4
        ),

        header.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
        header.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
        header.rightAnchor.constraint(equalTo: topContentView.rightAnchor),
        header.heightAnchor.constraint(equalToConstant: 18),
        header.topAnchor.constraint(
          equalTo: noteButton.bottomAnchor,
          constant: -3
        ),
        header.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -3),
      ]
    )

  }

  func setupBottomContentView() {
    addSetButton.setTitle("Add Set...", for: UIControl.State())
    addSetButton.translatesAutoresizingMaskIntoConstraints = false

    addSetButton.setBorder(
      color: .black,
      width: 1,
      radius: 0
    )

    bottomContentView.addSubview(addSetButton)

    NSLayoutConstraint.activate(
      [
        addSetButton.leftAnchor.constraint(
          equalTo: bottomContentView.leftAnchor
        ),
        addSetButton.rightAnchor.constraint(
          equalTo: bottomContentView.rightAnchor
        ),
        addSetButton.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
        addSetButton.bottomAnchor.constraint(
          equalTo: bottomContentView.bottomAnchor
        ),
      ]
    )
  }

  func setupChartView() {
    chartView.delegate = self
    chartView.emptyText = nil

    chartView.backgroundColor = .clear
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupTopContentView()
    setupBottomContentView()
    setupChartView()
    setupContentView()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension LiftCell: ConfigurableCell {

}
