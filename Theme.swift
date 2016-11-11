import UIKit

struct Theme {
    static func `do`() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSForegroundColorAttributeName: Colors.Nav.title
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.Nav.barTint
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.Tab.barTint
        tabBarAppearance.unselectedItemTintColor = .white
        
//        let barButtonItemAppearance = UIBarButtonItem.appearance()
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.Table.background
        
//        let labelAppearance = UILabel.appearance()
    }
    
    struct Colors {
        
        static var main = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static var dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static var light = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        static var lighter = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        
        struct Table {
            static var background = Colors.light
        }
        struct Nav {
            static var barTint = Colors.dark
            static var title = Colors.main
        }
        struct Tab {
            static var barTint = Colors.dark
        }
        
        
        static var outerTableViewBackground = Colors.light
        static var innerTableViewBackground = Colors.light
    }
    struct Fonts {
        struct Nav {
        }
    }
}
