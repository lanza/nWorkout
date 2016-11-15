import UIKit
import CoordinatorKit

class SettingsCoordinator: Coordinator {
    
    var settingsTVC: SettingsTVC { return viewController as! SettingsTVC }
    
    override func loadViewController() {
        viewController = SettingsTVC.new()
    }
}





