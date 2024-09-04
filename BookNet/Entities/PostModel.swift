//
//  ProfileEntity.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import Foundation

struct PostModel{
    
    var postId: String
    var userId: String
    var username: String
    var userProfileImageUrl: String
    let bookImageUrl: String
    let bookName: String
    let postText: String
    let creationDate: Date
    let autherName: String
    let likes: [String]?
    
    var hasLiked:Bool = false
    
    init(dictionary: [String:Any]) {
        self.userId = dictionary["userId"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.bookImageUrl = dictionary["bookImageUrl"] as? String ?? ""
        self.bookName = dictionary["bookName"] as? String ?? ""
        self.autherName = dictionary["authorName"] as? String ?? ""
        self.postText = dictionary["postText"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.likes = dictionary["likes"] as? [String] ?? []
    }
}


