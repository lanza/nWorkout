//import UIKit
//
//
//protocol AlertViewDelegate: class {
//  func onButtonTouchUpInside(view: AlertView, index: Int)
//}
//
//class AlertView: UIView {
//  var parent: UIView!
//  var dialogView: UIView!
//  var containerView: UIView!
//  
//  weak var delegate: AlertViewDelegate?
//  
//  var buttonTitles: [String]
//  var useMotionEffects: Bool = true
//  var closeOnTouchUpInside: Bool = true
//  
//  var onButtonTouchUpInside: ((AlertView, Int) -> ())? = nil
//  
//  init() {
//    super.init()
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  func show() {
//    
//  }
//  
//  func close() {
//    
//  }
//  
//  func dialogButtonTouchUpInside(sender: UIView) {
//    
//  }
//  
//  func setOnButtonTouchUpInside(closure: @escaping (AlertView,Int) -> ()) {
//    self.onButtonTouchUpInside = closure
//  }
//  
//  func deviceOrientationDidChange(noti: NSNotification) {
//    
//  }
//  
//  func dealloc() {
//    
//  }
//}
