//
//  BookModel.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//

import Foundation

struct BookModel{
    var id: String
    let userId: String?
    let imageUrl: String
    let bookName: String
    let creationDate: Date
    let authorName: String
    
    init(id:String, userId:String?, dictionary: [String:Any]) {
        self.id = id
        if let userId = userId{
            self.userId = userId
        }else{
            self.userId = dictionary["userId"] as? String ?? ""
        }
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.bookName = dictionary["bookName"] as? String ?? ""
        self.authorName = dictionary["authorName"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
