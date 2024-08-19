//
//  HomePresenterTests.swift
//  BookNetTests
//
//  Created by Abdulkadir Oruç on 19.08.2024.
//

import XCTest
@testable import Project

final class HomePresenterTests: XCTestCase {

    var presenter: HomePresenter!
    var mockView: MockHomeView!
    var mockInteractor: MockHomeInteractor!
    var mockWireframe: MockHomeWireframe!
    static let expectation = XCTestExpectation(description: "Fetch posts from Firebase")

    override func setUpWithError() throws {
        mockView = MockHomeView()
        mockInteractor = MockHomeInteractor()
        mockWireframe = MockHomeWireframe()
        presenter = HomePresenter(view: mockView, interactor: mockInteractor, wireframe: mockWireframe)
    }

    override func tearDownWithError() throws {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockWireframe = nil
    }

    func testViewDidLoadCallsFetchPosts() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchPostsCalled)
    }

    func testHandleRefreshClearsPostsAndFetches() {
        wait(for: [HomePresenterTests.expectation], timeout: 10.0)
        presenter.handleRefresh()
        XCTAssertTrue(mockView.reloadDataCalled)
        XCTAssertTrue(mockInteractor.fetchPostsCalled)
    }

    func testConfigureCell() {
        let cell = CustomPostCell()
        presenter.configureCell(cell, for: 0)
        
    }

    func testDidSelectPostNavigatesToProfile() {
        presenter.didSelectPost(at: 0)
        XCTAssertTrue(mockWireframe.navigateToProfileCalled)
    }
}

// Mock View
class MockHomeView: HomeViewInterface {

    var reloadDataCalled = false

    func reloadData() {
        HomePresenterTests.expectation.fulfill()
        reloadDataCalled = true
    }

    func endRefreshing() {
        
    }
}

// Mock Interactor
class MockHomeInteractor: HomeInteractorInputInterface {

    var fetchPostsCalled = false

    func fetchPosts() {
        fetchPostsCalled = true
    }
}

// Mock Wireframe
class MockHomeWireframe: HomeWireframeInterface {

    var navigateToProfileCalled = false

    func navigateToProfile(with userId: String) {
        navigateToProfileCalled = true
    }
}

