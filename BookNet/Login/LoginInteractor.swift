//
//  LoginInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.08.2024.
//

import FirebaseAuth

final class LoginInteractor {
    weak var presenter: LoginInteractorOutputInterface?
    private let userDefaults: UserDefaults
    
    init() {
        userDefaults = .standard
    }
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorInputInterface {
    
    func login(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] user, error in
            if let error = error{

                self?.presenter?.loginDidFail(error.localizedDescription)
                return
            }
            self?.userDefaults.set(true, forKey: Constants.UserDefaults.remember)
            
            self?.presenter?.loginDidSucceed(with: user?.user.uid ?? "")
        }
    }
}
