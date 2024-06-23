//
//  LoginPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?

    func loginButtonTapped(email: String, password: String) {
        view?.showLoading()
        interactor?.login(email: email, password: password)
    }
    
    func showSignUp(){
        router?.navigateToSignUpScreen(from: view!)
    }
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    func loginDidSucceed(with uid: String) {
        view?.hideLoading()
        router?.navigateToProfileScreen(from: view!,with: uid)
    }

    func loginDidFail(_ error: String) {
        view?.hideLoading()
        view?.showError(error)
    }
}

