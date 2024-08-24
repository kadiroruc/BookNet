//
//  LoginInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.08.2024.
//

import UIKit

protocol LoginWireframeInterface: WireframeInterface {
    
    // Presenter -> Router
    func navigateToProfileScreen()
    func navigateToSignUpScreen()
}

protocol LoginViewInterface: ViewInterface {
    
    // Presenter -> View
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateLoginButton(isEnabled: Bool)
}

protocol LoginPresenterInterface: PresenterInterface {
    
    // View -> Presenter
    func loginButtonTapped(email: String, password: String)
    func showSignUp()
    func handleTextInputChange(email: String?, password: String?)
}

protocol LoginInteractorInputInterface: InteractorInterface {
    // Presenter -> Interactor
    func login(email: String, password: String)
}

protocol LoginInteractorOutputInterface: PresenterInterface {
    // Interactor -> Presenter
    func loginDidSucceed(with uid: String)
    func loginDidFail(_ error: String)
}
