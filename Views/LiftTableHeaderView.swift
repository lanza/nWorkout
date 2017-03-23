import UIKit
import ChartView

class LiftTableHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var liftTableHeaderRowView: LiftTableHeaderRowView!
    
    init(type: LiftTableHeaderRowView.HeaderType) {
        switch type {
        case .routine:
            liftTableHeaderRowView = LiftTableHeaderRowView(type: .routine)
        case .workout:
            liftTableHeaderRowView = LiftTableHeaderRowView(type: .workout)
        case .statisticsHistory:
            liftTableHeaderRowView = LiftTableHeaderRowView(type: .statisticsHistory)
        }
        super.init(frame: .zero)
        backgroundColor = .darkGray
        setRV()
        setupViews()
        setNeedsLayout()
        
    }
    func setRV() {
        liftTableHeaderRowView = LiftTableHeaderRowView(type: .workout)
    }
    
    func setupViews() {
        addSubview(liftTableHeaderRowView)
        liftTableHeaderRowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liftTableHeaderRowView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1),
            liftTableHeaderRowView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            liftTableHeaderRowView.rightAnchor.constraint(equalTo: rightAnchor, constant: -1),
            liftTableHeaderRowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
            ])
    }
}




//class RoutineLiftTableHeaderView: LiftTableHeaderView {
//    override func setRV() {
//        liftTableHeaderRowView = RoutineLiftTableHeaderRowView()
//    }
//}
//
//
//class StatisticsHistoryTableHeaderView: LiftTableHeaderView {
//    override func setRV() {
//        liftTableHeaderRowView = StatisticsHistoryTableHeaderRowView()
//    }
//}





