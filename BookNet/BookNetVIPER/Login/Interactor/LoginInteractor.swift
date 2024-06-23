//
//  LoginInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import FirebaseAuth

class LoginInteractor: LoginInteractorInputProtocol {
    weak var presenter: LoginInteractorOutputProtocol?

    func login(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] user, error in
            if let error = error{
//                self?.showAlert(title: "Failed to Sign In", message: error.localizedDescription)
                self?.presenter?.loginDidFail(error.localizedDescription)
                return
            }
            self?.presenter?.loginDidSucceed(with: user?.user.uid ?? "")
        }
    }
}

