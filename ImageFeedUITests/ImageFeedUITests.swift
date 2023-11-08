
import XCTest

class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("eduardkarimov.rb@gmail.com")
        app.buttons["Done"].tap()
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("A2c2d2c2")
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        let webViewsQuery = webView.webViews
        webViewsQuery.buttons["Login"].tap()
        sleep(4)
        app.buttons["Authenticate"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cell.swipeUp(velocity: .slow)
        
        sleep(4)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        let likeButtonIdentifier = "likeButton"
        
        cellToLike.buttons[likeButtonIdentifier].tap()
        sleep(4)
        cellToLike.buttons[likeButtonIdentifier].tap()
                
        sleep(6)
        
        cellToLike.tap()
        
        sleep(6)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
                
        let navBackButtonWhiteButton = "backButton"
        app.buttons[navBackButtonWhiteButton].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        XCTAssertTrue(app.staticTexts["Eduard Karimov"].exists)
        XCTAssertTrue(app.staticTexts["@EduardKarimov"].exists)
        
        app.buttons["logOut"].tap()
        
        app.alerts["Вы точно хотите выйти?"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
