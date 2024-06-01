//
//  Request.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.06.2024.
//

import Foundation

struct Request{
    let senderId: String
    let receiverId: String
    let status: String
    
    init(dictionary: [String: Any]) {
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.receiverId = dictionary["receiverId"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
    }
}
