//
//  ProfileRouter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

class ProfileRouter: ProfileRouterProtocol {
    
    static func createProfileModule(with uid : String?) -> UIViewController {
        let viewController = ProfileView()
        let presenter: ProfilePresenterProtocol & ProfileInteractorOutputProtocol = ProfilePresenter()
        let interactor: ProfileInteractorInputProtocol = ProfileInteractor()
        let router: ProfileRouterProtocol = ProfileRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.uid = uid
        interactor.presenter = presenter
        
        return viewController
    }
    

    func presentLoginScreen(from view: ProfileViewProtocol) {
        let loginViewController = LoginRouter.createLoginModule()
   
        if let sourceView = view as? UIViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            sourceView.present(loginViewController, animated: true)
        }
    }
    
}

