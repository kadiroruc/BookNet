//
//  HomeViewTests.swift
//  BookNetTests
//
//  Created by Abdulkadir Oruç on 19.08.2024.
//

import XCTest
@testable import Project

final class HomeViewControllerTests: XCTestCase {

    var viewController: HomeViewController!
    var mockPresenter: MockHomePresenter!

    override func setUpWithError() throws {
        viewController = HomeViewController()
        mockPresenter = MockHomePresenter()
        viewController.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockPresenter = nil
    }

    func testViewDidLoadCallsPresenter() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }

    func testHandleRefreshCallsPresenter() {
        viewController.handleRefresh()
        XCTAssertTrue(mockPresenter.handleRefreshCalled)
    }


}

// Mock Presenter
class MockHomePresenter: HomePresenterInterface {

    var viewDidLoadCalled = false
    var handleRefreshCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func handleRefresh() {
        handleRefreshCalled = true
    }

    func numberOfPosts() -> Int {
        return 0
    }

    func configureCell(_ cell: CustomPostCell, for index: Int) {
        
    }

    func didSelectPost(at index: Int) {
        
    }
}

