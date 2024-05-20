//
//  FirebaseExtension.swift
//  Project
//
//  Created by Abdulkadir Oruç on 25.04.2024.
//

import FirebaseDatabase

extension Database{
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userDictionary = snapshot.value as? [String:Any] else{return}
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }
    }
}
