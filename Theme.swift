import UIKit

struct Theme {
    static func setupAppearances() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: Fonts.boldTitle,
            NSForegroundColorAttributeName: Colors.tint
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.foreground
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.foreground
        tabBarAppearance.unselectedItemTintColor = .white
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        let attr = [ NSFontAttributeName: Fonts.title ]
        barButtonItemAppearance.setTitleTextAttributes(attr, for: UIControlState())
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.background
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.font = Fonts.title
    }
    
    struct Colors {
        
        static var main = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static var dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static var light = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        static var lighter = #colorLiteral(red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
        
        static var tint = Colors.main
        static var background = Colors.lighter
        static var lightBackground = Colors.light
        static var sectionHeader = Colors.main
        static var foreground = Colors.dark
        static var lightText = UIColor(red: 0.64, green: 0.65, blue: 0.8, alpha: 1)
        
        static var outerTableViewBackground = Colors.light
        static var innerTableViewBackground = Colors.light
    }
    struct Fonts {
        static let boldTitle = UIFont.boldSystemFont(ofSize: 17)
        static let title = UIFont.boldSystemFont(ofSize: 16)
        static let subtitle = UIFont.boldSystemFont(ofSize: 13)
        
        static let tableHeader = UIFont.boldSystemFont(ofSize: 10)
        static let cellNameLabel = UIFont.boldSystemFont(ofSize: 16)
    }
}
