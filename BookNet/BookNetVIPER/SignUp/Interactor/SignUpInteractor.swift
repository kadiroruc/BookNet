//
//  SignUpInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

class SignUpInteractor: SignUpInteractorInputProtocol {
    weak var presenter: SignUpInteractorOutputProtocol?

    func signUp(username: String, password: String, email: String) {
//        // Perform sign-up logic, for example:
//        if username.isEmpty || password.isEmpty || email.isEmpty {
//            presenter?.signUpDidFail("All fields are required")
//        } else {
//            // Assume success for simplicity
//            presenter?.signUpDidSucceed()
//        }
        
        presenter?.signUpDidSucceed()
    }
}

