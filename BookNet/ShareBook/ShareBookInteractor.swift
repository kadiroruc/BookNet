//
//  ShareBookInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit
import Firebase
import FirebaseStorage


final class ShareBookInteractor {
    
    weak var presenter: ShareBookInteractorOutputInterface?
}

// MARK: - Extensions -

extension ShareBookInteractor: ShareBookInteractorInterface {
    
    
    func uploadPost(bookName: String, authorName: String, postText: String, image: UIImage) {
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5)else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        
        storageRef.putData(uploadData) {[weak self] metadata, error in
            if let error = error{
                DispatchQueue.main.async {
                    self?.presenter?.didFailToUploadPost(error.localizedDescription)
                }
                return
            }
            storageRef.downloadURL { url, error in
                if let imageUrl = url{
                    
                    guard let uid = Auth.auth().currentUser?.uid else{return}
                    guard let username = Auth.auth().currentUser?.displayName else{return}
                    
                    let databaseRef = Database.database().reference().child("posts").child(uid)
                    let postRef = databaseRef.childByAutoId()
                    let values = ["userId":uid,
                                  "username":username,
                                  "userProfileImageUrl":Auth.auth().currentUser?.photoURL?.absoluteString ?? "",
                                  "postId":postRef.key,
                                  "bookImageUrl":imageUrl.absoluteString,
                                  "bookName":bookName,
                                  "authorName":authorName,
                                  "postText":postText,
                                  "imageWidth":image.size.width,
                                  "imageHeight":image.size.height,
                                  "creationDate":Date().timeIntervalSince1970] as [String:Any]
                    
                    postRef.updateChildValues(values) {error, ref in
                        if let error = error{
                            DispatchQueue.main.async {
                                self?.presenter?.didFailToUploadPost(error.localizedDescription)
                            }
                            return
                        }else{
                            DispatchQueue.main.async {
                                self?.presenter?.didUploadPost()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
}
