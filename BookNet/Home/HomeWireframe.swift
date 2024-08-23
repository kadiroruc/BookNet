//
//  HomeWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import UIKit

final class HomeWireframe: BaseWireframe<HomeViewController> {

    init() {
        let moduleViewController = HomeViewController()
        super.init(viewController: moduleViewController)
        
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }

}

extension HomeWireframe: HomeWireframeInterface {
    func navigateToProfile(with userId: String) {

        
        let profileWireFrame = ProfileWireframe(uid: userId)
        let profileVC = profileWireFrame.viewController
        profileVC.titleLabel.isHidden = true
    
        navigationController?.pushWireframe(profileWireFrame, animated: true)
    }
}
