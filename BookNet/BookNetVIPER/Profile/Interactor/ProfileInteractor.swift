//
//  ProfileInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import FirebaseAuth
import FirebaseDatabase

class ProfileInteractor: ProfileInteractorInputProtocol {
    
    weak var presenter: ProfileInteractorOutputProtocol?
    
    func fetchUserProfile(for uid: String?) {
        
        if let uid = uid{
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) {[weak self] snapshot,arg  in
                guard let userDictionary = snapshot.value as? [String:Any] else{return}
                let user = UserModel(uid: uid, dictionary: userDictionary)
                
                self?.presenter?.didFetchUserProfile(user)
            }
        }
        
    }
    
    func fetchUserPosts() {
        
    }
    
    func userLogOut() {
        do{
            try Auth.auth().signOut()
            presenter?.didUserLogOut()
        }catch{
            presenter?.onError()
        }
    }
        
}


