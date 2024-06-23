//
//  SignUpRouter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

class SignUpRouter: SignUpRouterProtocol {
    static func createSignUpModule() -> UIViewController {
        let view = SignUpView()
        let presenter: SignUpPresenterProtocol & SignUpInteractorOutputProtocol = SignUpPresenter()
        let interactor: SignUpInteractorInputProtocol = SignUpInteractor()
        let router: SignUpRouterProtocol = SignUpRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }

    func navigateToLoginScreen(from view: SignUpViewProtocol) {
        
        let loginViewController = LoginRouter.createLoginModule()
   
        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}

