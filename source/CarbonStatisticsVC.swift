import UIKit

class CarbonStatisticsVC: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  init(liftName: String) {
    self.liftName = liftName
    super.init(nibName: nil, bundle: nil)
    title = liftName
  }

  let liftName: String

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Theme.Colors.darkest

    //    let items = ["History", "Charts"]  //,"PR"]
    //    let c = CarbonTabSwipeNavigation(items: items, delegate: self)
    //
    //    c.setTabBarHeight(44)
    //
    //    c.setNormalColor(Theme.Colors.dark)
    //    c.setSelectedColor(Theme.Colors.main)
    //    c.setIndicatorColor(Theme.Colors.main)
    //
    //    let count = CGFloat(items.count)
    //    c.carbonSegmentedControl?.setWidth(
    //      view.frame.width / count,
    //      forSegmentAt: 0
    //    )
    //    c.carbonSegmentedControl?.setWidth(
    //      view.frame.width / count,
    //      forSegmentAt: 1
    //    )
    //    //        c.carbonSegmentedControl?.setWidth(view.frame.width / count, forSegmentAt: 2)
    //
    //    c.insert(intoRootViewController: self)
  }

  //  func carbonTabSwipeNavigation(
  //    _ carbonTabSwipeNavigation: CarbonTabSwipeNavigation,
  //    viewControllerAt index: UInt
  //  ) -> UIViewController {
  //    switch index {
  //    case 0:
  //      return StatisticsHistoryTVC(liftName: liftName)
  //    case 1:
  //      return StatisticsChartsTVC(liftName: liftName)
  //    case 2:
  //      return StatisticsPersonalRecordTVC(liftName: liftName)
  //    default: fatalError()
  //    }
  //  }
}
