import XCTest
@testable import nWorkout

class SnapshotTarget: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
    
        
        snapshot("history")
        
        app.tabBars.buttons["Routines"].tap()
        snapshot("routines")
        
        app.tabBars.buttons["Show"].tap()
        snapshot("workout")
        
        app.navigationBars["3:21 AM"].buttons["Hide"].tap()
        app.tabBars.buttons["Statistics"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Statistics"].tap()
        tablesQuery.staticTexts["Squat"].tap()
        XCUIApplication().toolbars.segmentedControls.buttons["Charts"].tap()
        snapshot("statistics")          
    }
    
}
