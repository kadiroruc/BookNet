//
//  SearchWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.08.2024.
//

import UIKit

final class SearchWireframe: BaseWireframe<SearchViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = SearchViewController()
        super.init(viewController: moduleViewController)

        let interactor = SearchInteractor()
        let presenter = SearchPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension SearchWireframe: SearchWireframeInterface {
    func navigateToProfile(with userId: String) {

        
        let profileWireFrame = ProfileWireframe(uid: userId)
        let profileVC = profileWireFrame.viewController
        profileVC.titleLabel.isHidden = true
        profileVC.followButton.isHidden = false
        
        navigationController?.pushWireframe(profileWireFrame, animated: true)
    }
    
}
