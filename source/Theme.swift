import UIKit

struct Theme {
  struct Colors {
    static let clear = #colorLiteral(
      red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let main = #colorLiteral(
      red: 0.3028615713, green: 0.5040465593, blue: 0.7695046067, alpha: 1)

    static let dark = #colorLiteral(
      red: 0.2128070295, green: 0.251644671, blue: 0.3068907559, alpha: 1)
    static let darker = #colorLiteral(
      red: 0.1975900531, green: 0.2120065689, blue: 0.2376480997, alpha: 1)
    static let light = #colorLiteral(
      red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)
    static let lighter = #colorLiteral(
      red: 0.9568895725, green: 0.9568895725, blue: 0.9568895725, alpha: 1)

    struct Button {
      static let title = Colors.main
    }

    struct Table {
      static let borders = UIColor.darkGray
    }
    struct Nav {
      static let title = UIColor.white
      static let tint = UIColor.white
    }
    struct Tab {
      static let barTint = Colors.darker
      static let tint = Colors.main
      static let unselectedItemTint = UIColor.white
    }
    struct Cell {
      static let contentBackground = Colors.dark
    }
    struct Keyboard {
      static let background = #colorLiteral(
        red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      static let keys = UIColor.white
    }
  }
  struct Fonts {
    struct Nav {
    }
  }
}
