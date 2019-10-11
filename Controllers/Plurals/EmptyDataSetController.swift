import DZNEmptyDataSet
import UIKit

class EmptyDataSetController: NSObject, DZNEmptyDataSetSource,
  DZNEmptyDataSetDelegate
{

  var imageForEmptyDataSet: UIImage?
  var imageTintColorForEmptyDataSet: UIColor?
  var titleForEmptyDataSet: NSAttributedString?
  var descriptionForEmptyDataSet: NSAttributedString?
  var verticalOffsetForEmptyDataSet: CGFloat?

  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return imageForEmptyDataSet
  }

  func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return imageTintColorForEmptyDataSet
  }

  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return titleForEmptyDataSet
  }

  func description(forEmptyDataSet scrollView: UIScrollView!)
    -> NSAttributedString!
  {
    return descriptionForEmptyDataSet
  }

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return verticalOffsetForEmptyDataSet ?? 0
  }
}
