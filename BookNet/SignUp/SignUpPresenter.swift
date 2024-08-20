//
//  SignUpPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.07.2024.
//

import Foundation

final class SignUpPresenter {
    
    // MARK: - Private properties -

    private unowned var view: SignUpViewInterface
    private var interactor: SignUpInteractorInputInterface
    private let wireframe: SignUpWireframeInterface

    // MARK: - Lifecycle -

    init(view: SignUpViewInterface, interactor: SignUpInteractorInputInterface, wireframe: SignUpWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SignUpPresenter: SignUpPresenterInterface {

    
    func signUpButtonTapped(username: String, password: String, email: String) {
        view.showLoading()
        interactor.signUp(username: username, password: password, email: email)
    }
    
    func showLogin() {
        wireframe.navigateToLoginScreen()
    }
    
    func handleTextInputChange(email: String?, password: String?, username: String?) {
        let isFormValid = (email?.count ?? 0 > 0) && (password?.count ?? 0 > 0) && (username?.count ?? 0 > 0)
        view.updateSignUpButton(isEnabled: isFormValid)
    }
    
}

extension SignUpPresenter: SignUpInteractorOutputInterface{
    func signUpDidSucceed(with uid: String) {
        view.hideLoading()
        //wireframe.navigateToProfileScreen(with: uid)
    }
    
    func signUpDidFail(_ error: String) {
        view.hideLoading()
        view.showError(error)
    }
    
    
}
