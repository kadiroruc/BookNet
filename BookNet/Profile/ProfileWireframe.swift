//
//  ProfileWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//

import UIKit

final class ProfileWireframe: BaseWireframe<ProfileViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init(uid: String?) {
        let moduleViewController = ProfileViewController()
        super.init(viewController: moduleViewController)

        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: moduleViewController, interactor: interactor, wireframe: self,uid: uid)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ProfileWireframe: ProfileWireframeInterface {
    func navigateToLoginScreen() {
        viewController.tabBarController?.tabBar.isHidden = true
        navigationController?.setRootWireframe(LoginWireframe())
    }
    
}
