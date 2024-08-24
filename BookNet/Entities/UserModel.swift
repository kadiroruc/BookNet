//
//  UserModel.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

struct UserModel{
    let username: String
    let profileImageUrl: String
    let uid: String
    let location: String
    
    init(uid: String, dictionary: [String:Any]){
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.uid = uid
    }
}

