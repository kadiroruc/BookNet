//
//  ProfileInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//
//  This file was generated by the 🐍 VIPER generator
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import UIKit

final class ProfileInteractor {
    
    weak var presenter: ProfileInteractorOutputInterface?
}

// MARK: - Extensions -

extension ProfileInteractor: ProfileInteractorInputInterface {
    
    
    func fetchUserProfile(for uid: String?) {
        
        guard let uid = uid else {return}
    
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) {[weak self] snapshot,arg  in
            guard let userDictionary = snapshot.value as? [String:Any] else{return}
            let user = UserModel(uid: uid, dictionary: userDictionary)
            
            self?.presenter?.didFetchUserProfile(user)
        }
        
    }
    
    func fetchUserBooks(for uid: String?){
        var books = [BookModel]()
        
        guard let uid = uid else {return}

        let ref = Database.database().reference().child("books").child(uid)
        ref.observe(.childAdded) {[weak self] snapshot,arg  in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            let key = snapshot.key
            let book = BookModel(id: key, userId: nil, dictionary: dictionary)
            
            books.insert(book, at: 0)
            print(books)
            
            self?.presenter?.didFetchUserBooks(books)
        }
    }
    
    func fetchUserPosts(for user: UserModel?) {
    
        guard let user = user else {return}
        
        var posts = [PostModel]()
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.childAdded) {[weak self] snapshot in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            let key = snapshot.key
            

            
            let post = PostModel(user: user, dictionary: dictionary)
            
            posts.insert(post, at: 0)
            
            self?.presenter?.didFetchUserPosts(posts)
            
        }
    }
    
    func userLogOut() {
        do{
            try Auth.auth().signOut()
            presenter?.didUserLogOut()
        }catch{
            presenter?.onError("Failed to log out")
        }
    }
    
    func uploadProfileImage(user: UserModel, image: UIImage) {
        
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else{return}
        
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(uploadData) {[weak self] metadata, error in
            
            if let error = error{
                self?.presenter?.onError(error.localizedDescription)
                return
            }
            
            let uid = user.uid
            
            storageRef.downloadURL { url, error in
                if let imageUrl = url{
                    let profileImageUrl = imageUrl.absoluteString
                    
                    let dictionaryValues = ["username":user.username, "profileImageUrl":profileImageUrl]
                    
                    let values = [uid:dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { err, ref in
                        if error != nil{
                            self?.presenter?.onError("Failed to save user info into db")
                            return
                        }
        
                        self?.presenter?.updateProfileImage(with: profileImageUrl)
                        
                    })
                }
            }
        }

    }
    
}
