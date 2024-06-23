//
//  SignUpProtocols.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

protocol SignUpViewProtocol: AnyObject {
    var presenter: SignUpPresenterProtocol? { get set }
    // Presenter -> View
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

protocol SignUpInteractorInputProtocol: AnyObject {
    var presenter: SignUpInteractorOutputProtocol? { get set }
    // Presenter -> Interactor
    func signUp(username: String, password: String, email: String)
}

protocol SignUpInteractorOutputProtocol: AnyObject {
    // Interactor -> Presenter
    func signUpDidSucceed()
    func signUpDidFail(_ error: String)
}

protocol SignUpPresenterProtocol: AnyObject {
    var view: SignUpViewProtocol? { get set }
    var interactor: SignUpInteractorInputProtocol? { get set }
    var router: SignUpRouterProtocol? { get set }

    // View -> Presenter
    func signUpButtonTapped(username: String, password: String, email: String)
    func showLogin()
}

protocol SignUpRouterProtocol: AnyObject {
    // Presenter -> Router
    static func createSignUpModule() -> UIViewController
    func navigateToLoginScreen(from view: SignUpViewProtocol)
}

