//
//  HomeInteractorTests.swift
//  BookNetTests
//
//  Created by Abdulkadir Oruç on 19.08.2024.
//

import XCTest
@testable import Project

final class HomeInteractorTests: XCTestCase {

    var interactor: HomeInteractor!
    var mockPresenter: MockHomeOutputPresenter!
    static let expectation = XCTestExpectation(description: "Fetch posts from Firebase")

    override func setUpWithError() throws {
        interactor = HomeInteractor()
        mockPresenter = MockHomeOutputPresenter()
        interactor.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockPresenter = nil
    }

    func testFetchPostsSuccess() {
        
        interactor.fetchPosts()

        wait(for: [HomeInteractorTests.expectation], timeout: 10.0)
        XCTAssertTrue(mockPresenter.didFetchPostsCalled)
    }
}

// Mock Presenter
class MockHomeOutputPresenter: HomeInteractorOutputInterface {
    

    var didFetchPostsCalled = false

    func didFetchPosts(_ posts: [Project.PostModel]) {
        didFetchPostsCalled = true
        HomeInteractorTests.expectation.fulfill()
    }

    func didFailToFetchPosts(with error: Error) {
        // Handle error in test
    }
}
