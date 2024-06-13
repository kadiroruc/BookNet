//
//  Request.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.06.2024.
//

import Foundation

struct Request{
    let id: String
    let senderId: String
    let receiverId: String
    let status: String
    let requestedBook: String
    let email: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.receiverId = dictionary["receiverId"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
        self.requestedBook = dictionary["requestedBook"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
