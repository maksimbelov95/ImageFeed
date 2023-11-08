@testable import ImageFeed
import XCTest

final class TestPresenterCallsLoadRequest: XCTestCase {
    func testPresenterCallsLoadRequest() {

        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
    }
}
