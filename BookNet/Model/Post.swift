//
//  Post.swift
//  Project
//
//  Created by Abdulkadir Oruç on 25.04.2024.
//

import Foundation

struct Post{
    
    var id: String?
    let user: User
    let imageUrl: String
    let label: String
    let description: String
    let creationDate: Date
    
    var hasLiked:Bool = false
    
    init(user:User, dictionary: [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.label = dictionary["label"] as? String ?? ""
        self.description = dictionary["label"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
