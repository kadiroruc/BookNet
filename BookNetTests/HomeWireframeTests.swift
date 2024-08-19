//
//  HomeWireframeTests.swift
//  BookNetTests
//
//  Created by Abdulkadir Oruç on 19.08.2024.
//

import XCTest
import FirebaseAuth
@testable import Project

final class HomeWireframeTests: XCTestCase {

    var wireframe: MockHomeWireframeClass!

    override func setUpWithError() throws {
        wireframe = MockHomeWireframeClass()
    }

    override func tearDownWithError() throws {
        wireframe = nil
    }

    func testNavigateToProfile() {
        
        guard let userId = Auth.auth().currentUser?.uid else{return}
        wireframe.navigateToProfile(with: userId )

        XCTAssertTrue(wireframe.navigateToProfileCalled)
    }
}

// Mock ViewController
class MockHomeViewController: HomeViewController {

    var navigateToProfileCalled = false

    func navigateToProfile(with userId: String) {
        navigateToProfileCalled = true
    }
}


final class MockHomeWireframeClass: BaseWireframe<HomeViewController> {

    init() {
        let moduleViewController = HomeViewController()
        super.init(viewController: moduleViewController)
        
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }
    
    var navigateToProfileCalled = false

}

extension MockHomeWireframeClass: HomeWireframeInterface {
    func navigateToProfile(with userId: String) {

        self.navigateToProfileCalled = true
        let profileWireFrame = ProfileWireframe(uid: userId)
        let profileVC = profileWireFrame.viewController
        profileVC.titleLabel.isHidden = true
        profileVC.followButton.isHidden = false
    
        navigationController?.pushWireframe(profileWireFrame, animated: true)
    }
}

