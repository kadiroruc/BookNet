//
//  SignUpPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?
    var interactor: SignUpInteractorInputProtocol?
    var router: SignUpRouterProtocol?

    func signUpButtonTapped(username: String, password: String, email: String) {
        view?.showLoading()
        interactor?.signUp(username: username, password: password, email: email)
    }
    
    func showLogin(){
        router?.navigateToLoginScreen(from: view!)
    }
}

extension SignUpPresenter: SignUpInteractorOutputProtocol {
    func signUpDidSucceed() {
        view?.hideLoading()
        router?.navigateToLoginScreen(from: view!)
    }

    func signUpDidFail(_ error: String) {
        view?.hideLoading()
        view?.showError(error)
    }
}

