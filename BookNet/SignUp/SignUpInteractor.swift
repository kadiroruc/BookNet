//
//  SignUpInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.07.2024.
//

import FirebaseAuth
import FirebaseDatabase

final class SignUpInteractor {
    weak var presenter: SignUpInteractorOutputInterface?

}

// MARK: - Extensions -

extension SignUpInteractor: SignUpInteractorInputInterface {
    
    func signUp(username: String, password: String, email: String, location: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] user, error in
            if let error = error{
                self?.presenter?.signUpDidFail(error.localizedDescription)
                return
            }
            
            guard let uid = user?.user.uid else{return}
            let dictionaryValues = ["username":username, "location":location]
            let values = [uid:dictionaryValues]
            
            Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { err, ref in
                if let err = error{
                    
                    return
                }
                

                self?.presenter?.signUpDidSucceed(with: uid)
            })
        }
        
        
    }
}
