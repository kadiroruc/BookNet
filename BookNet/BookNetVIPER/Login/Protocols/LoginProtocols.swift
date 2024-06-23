//
//  Protocols.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    // Presenter -> View
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

protocol LoginInteractorInputProtocol: AnyObject {
    var presenter: LoginInteractorOutputProtocol? { get set }
    // Presenter -> Interactor
    func login(email: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    // Interactor -> Presenter
    func loginDidSucceed(with uid: String)
    func loginDidFail(_ error: String)
}

protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }

    // View -> Presenter
    func loginButtonTapped(email: String, password: String)
    func showSignUp()
}

protocol LoginRouterProtocol: AnyObject {
    // Presenter -> Router
    static func createLoginModule() -> UIViewController
    func navigateToProfileScreen(from view: LoginViewProtocol,with uid: String)
    func navigateToSignUpScreen(from view: LoginViewProtocol)
}

