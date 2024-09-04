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
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            if let error = error{
                self?.presenter?.signUpDidFail(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            
            // Kullanıcının profilini güncelleme (displayName ayarlama)
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating display name: \(error.localizedDescription)")
                } else {
                    print("Display name updated successfully")
                }
            }
            
            let dictionaryValues = ["username":username, "location":location]
            let values = [user.uid:dictionaryValues]
            
            Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { err, ref in
                if let err = error{return}
                
                self?.presenter?.signUpDidSucceed(with: user.uid)
                
            })
        }
    }
}
