//
//  ProfileEntity.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

struct PostModel{
    
    var id: String?
    let user: User
    let bookImageUrl: String
    let bookName: String
    let postText: String
    let creationDate: Date
    let autherName: String
    
    var hasLiked:Bool = false
    
    init(user:User, dictionary: [String:Any]) {
        self.user = user
        self.bookImageUrl = dictionary["bookImageUrl"] as? String ?? ""
        self.bookName = dictionary["bookName"] as? String ?? ""
        self.autherName = dictionary["authorName"] as? String ?? ""
        self.postText = dictionary["postText"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}


