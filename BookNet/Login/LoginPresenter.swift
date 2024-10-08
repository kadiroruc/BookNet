//
//  LoginPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.08.2024.
//

import Foundation

final class LoginPresenter {
    
    // MARK: - Private properties -

    private unowned let view: LoginViewInterface
    private let interactor: LoginInteractorInputInterface
    private let wireframe: LoginWireframeInterface

    // MARK: - Lifecycle -

    init(view: LoginViewInterface, interactor: LoginInteractorInputInterface, wireframe: LoginWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
    func loginButtonTapped(email: String, password: String) {
        view.showLoading()
        interactor.login(email: email, password: password)
    }
    
    func showSignUp() {
        wireframe.navigateToSignUpScreen()
    }
    
    func handleTextInputChange(email: String?, password: String?) {
        let isFormValid = (email?.count ?? 0 > 0) && (password?.count ?? 0 > 0)
        view.updateLoginButton(isEnabled: isFormValid)
    }
    
}

extension LoginPresenter: LoginInteractorOutputInterface {
    func loginDidSucceed(with uid: String) {
        view.hideLoading()
        wireframe.navigateToProfileScreen()
    }

    func loginDidFail(_ error: String) {
        view.hideLoading()
        view.showError(error)
    }
}


