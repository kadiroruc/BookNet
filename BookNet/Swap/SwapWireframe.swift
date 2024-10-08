//
//  SwapWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class SwapWireframe: BaseWireframe<SwapViewController> {

    init() {
        let moduleViewController = SwapViewController()
        super.init(viewController: moduleViewController)
        
        let interactor = SwapInteractor()
        let presenter = SwapPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension SwapWireframe: SwapWireframeInterface {
    
    func navigateToProfile(userId: String) {
        let profileWireFrame = ProfileWireframe(uid: userId)
        let profileVC = profileWireFrame.viewController
        profileVC.titleLabel.isHidden = true
        profileVC.followButton.isHidden = false
    
        navigationController?.pushWireframe(profileWireFrame, animated: true)
    }
}
