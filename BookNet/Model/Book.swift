//
//  Book.swift
//  Project
//
//  Created by Abdulkadir Oruç on 26.05.2024.
//

import Foundation

struct Book{
    var id: String
    let user: User?
    let imageUrl: String
    let bookName: String
    let creationDate: Date
    let authorName: String
    
    init(id:String, user:User?, dictionary: [String:Any]) {
        self.id = id
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.bookName = dictionary["bookName"] as? String ?? ""
        self.authorName = dictionary["authorName"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
