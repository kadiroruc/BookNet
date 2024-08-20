//
//  SignUpInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.07.2024.
//

import UIKit

protocol SignUpWireframeInterface: WireframeInterface {
    
    func navigateToProfileScreen(with uid: String)
    func navigateToLoginScreen()
}

protocol SignUpViewInterface: ViewInterface {
    // Presenter -> View
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateSignUpButton(isEnabled: Bool)
}

protocol SignUpInteractorInputInterface: InteractorInterface {
    // Presenter -> Interactor
    func signUp(username: String, password: String, email: String)
}

protocol SignUpInteractorOutputInterface: PresenterInterface {
    // Interactor -> Presenter
    func signUpDidSucceed(with uid: String)
    func signUpDidFail(_ error: String)
}

protocol SignUpPresenterInterface: PresenterInterface {

    // View -> Presenter
    func signUpButtonTapped(username: String, password: String, email: String)
    func showLogin()
    func handleTextInputChange(email: String?, password: String?, username: String?)
}

protocol SignUpInteractorInterface: InteractorInterface {
}
