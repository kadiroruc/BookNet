//
//  User.swift
//  Project
//
//  Created by Abdulkadir Oruç on 25.04.2024.
//

import Foundation

struct User{
    let username: String
    let profileImageUrl: String
    let uid: String
    
    init(uid: String, dictionary: [String:Any]){
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}

