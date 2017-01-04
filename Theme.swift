import UIKit

struct Theme {
    static func `do`() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSForegroundColorAttributeName: Colors.Nav.title
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.Nav.barTint
        navBarAppearance.tintColor = Colors.Nav.tint
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.Tab.barTint
        tabBarAppearance.tintColor = Colors.Tab.tint
        tabBarAppearance.unselectedItemTintColor = Colors.Tab.unselectedItemTint
        
//        let barButtonItemAppearance = UIBarButtonItem.appearance()
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.Table.background
        
        let buttonAppearance = UIButton.appearance()
        buttonAppearance.setTitleColor(Colors.Button.title, for: UIControlState())
        
//        let labelAppearance = UILabel.appearance()
    }
    
    struct Colors {
        
        static let main = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        static let dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let light = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        static let lighter = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        
        struct Button {
            static let title = Colors.main
        }
        
        struct Table {
            static let background = Colors.light
        }
        struct Nav {
            static let barTint = Colors.dark
            static let title = Colors.main
            static let tint = Colors.main
        }
        struct Tab {
            static let barTint = Colors.dark
            static let tint = Colors.main
            static let unselectedItemTint = UIColor.white       
        }
        struct Keyboard {
            static let background = Colors.dark
            static let keys = Colors.main
        }
        
        
        static var outerTableViewBackground = Colors.light
        static var innerTableViewBackground = Colors.light
    }
    struct Fonts {
        struct Nav {
        }
    }
}
