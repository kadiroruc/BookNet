//
//  ProfileInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
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
    
    func checkIfFollowing(currentUserId: String, userId: String) {
        
            Database.database().reference().child("following").child(currentUserId).child(userId).observeSingleEvent(of: .value) { snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.presenter?.didCheckIfFollowing(isFollowing: true)
                } else {
                    self.presenter?.didCheckIfFollowing(isFollowing: false)
                }
            }
        }

        func followUser(currentUserId: String, userId: String) {
            let ref = Database.database().reference().child("following").child(currentUserId)
            let values = [userId: 1]
            
            ref.updateChildValues(values) { error, _ in
                if error == nil {
                    self.presenter?.didFollowUser()
                }
            }
        }

        func unfollowUser(currentUserId: String, userId: String) {
            Database.database().reference().child("following").child(currentUserId).child(userId).removeValue { error, _ in
                if error == nil {
                    self.presenter?.didUnfollowUser()
                }
            }
        }
    
    func fetchFollowingCount(forUserId userId: String) {
        let ref = Database.database().reference().child("following").child(userId)

        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let followingDict = snapshot.value as? [String: Any] {
                    self.presenter?.didFetchFollowingCount(followingDict.count)
                } else {
                    self.presenter?.didFetchFollowingCount(0)
                }
            } else {
                self.presenter?.didFetchFollowingCount(0)
            }
        }
    }

    func fetchFollowerCount(forUserId userId: String) {
        let ref = Database.database().reference().child("following")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var followerCount = 0
            
            if let followingDict = snapshot.value as? [String: [String: Any]] {
                for (_, userFollowing) in followingDict {
                    if userFollowing[userId] != nil {
                        followerCount += 1
                    }
                }
            }
            
            self.presenter?.didFetchFollowerCount(followerCount)
        }
    }
    
    
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
            
            self?.presenter?.didFetchUserBooks(books)
        }
    }
    
    func fetchUserPosts(for user: UserModel?) {
    
        guard let user = user else {return}
        
        var posts = [PostModel]()
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.childAdded) {[weak self] snapshot in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}

            let post = PostModel(dictionary: dictionary)
            
            posts.insert(post, at: 0)
            
            self?.presenter?.didFetchUserPosts(posts)
            
        }
    }
    
    func userLogOut() {
        do{
            try Auth.auth().signOut()
            presenter?.didUserLogOut()
        }catch{
            presenter?.showMessage("Failed to log out")
        }
    }
    
    func uploadProfileImage(user: UserModel, image: UIImage) {
        
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else{return}
        
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(uploadData) {[weak self] metadata, error in
            
            if let error = error{
                self?.presenter?.showMessage(error.localizedDescription)
                return
            }
            
            let uid = user.uid
            
            storageRef.downloadURL { url, error in
                if let imageUrl = url{
                    let profileImageUrl = imageUrl.absoluteString

                    let dictionaryValues = ["username":user.username,"location":user.location, "profileImageUrl":profileImageUrl]
                    
                    let values = [uid:dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { err, ref in
                        if error != nil{
                            self?.presenter?.showMessage("Failed to save user info into db")
                            return
                        }
        
                        self?.presenter?.updateProfileImage(with: profileImageUrl)
                        
                        if let user = Auth.auth().currentUser {
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.photoURL = URL(string: profileImageUrl)
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    print("Error updating profile: \(error.localizedDescription)")
                                } else {
                                    print("Profile photo updated successfully")
                                }
                            }
                        }
                        
                    })
                }
            }
        }

    }

    func deletePost(forUserId userId: String, postId: String, index: Int) {
        let postRef = Database.database().reference().child("posts").child(userId).child(postId)

        postRef.removeValue {[weak self] error, _ in
            if let error = error {
                self?.presenter?.showMessage(error.localizedDescription)
            } else {
                self?.presenter?.didDeletePost(at: index)
            }
        }
    }
    
    func deleteBook(userId: String, bookId: String, index: Int) {
        let postRef = Database.database().reference().child("books").child(userId).child(bookId)

        postRef.removeValue {[weak self] error, _ in
            if let error = error {
                self?.presenter?.showMessage(error.localizedDescription)
            } else {
                self?.presenter?.didDeleteBook(at: index)
            }
        }
    }

    func checkDidRequestedBefore(senderId: String, receiverId: String, email: String, requestedBook: String) {
        
        let ref = Database.database().reference().child("requests")
        var requested = false
        
        ref.observeSingleEvent(of: .value) {[weak self] snapshot,arg   in
            guard let dictionaries = snapshot.value as? [String:Any] else{
                self?.sendRequest(senderId: senderId, receiverId: receiverId, email: email, requestedBook: requestedBook)
                return
            }
            
            dictionaries.forEach { key,value in
                guard let requestDictionaries = value as? [String:Any] else {
                    return
                }
                
                if requestDictionaries["senderId"] as! String == senderId, requestDictionaries["receiverId"] as! String == receiverId, requestDictionaries["status"] as! String == "pending"{
                    requested = true
                    
                    
                }
            }
            if !requested{
                self?.sendRequest(senderId: senderId, receiverId: receiverId, email: email, requestedBook: requestedBook)
            }else{
                self?.presenter?.didRequestedBefore()
            }
            
        }
    }
    
    func sendRequest(senderId: String, receiverId: String, email: String, requestedBook: String){
        
        let ref = Database.database().reference().child("requests").childByAutoId()
        let autoID = ref.key
        
        let value = ["id":autoID,
                     "requestedBook":requestedBook,
                     "senderId":senderId,
                     "receiverId": receiverId,
                     "status":"pending",
                     "email":email]
        
        ref.setValue(value) {[weak self] error, ref in
            if error != nil{
                self?.presenter?.showMessage("Error sending request!")
                return
            }
            self?.presenter?.showMessage("Request sent successfully.")
        }
    }
    
    func changeLocation(for userId: String, newLocation: String) {
        let ref = Database.database().reference().child("users").child(userId).child("location")
        
        ref.setValue(newLocation) {[weak self] error, _ in
            if error != nil{
                self?.presenter?.showMessage("Error changing location")
            }else{
                self?.presenter?.didChangeLocation(newLocation)
            }
        }
        
    }
    
    func checkBlock(currentUserId: String, userId: String) {
        let ref = Database.database().reference().child("users").child(currentUserId).child("blockedUsers")
        
        ref.child(userId).observeSingleEvent(of: .value) {[weak self] snapshot in
            if snapshot.exists() {
                // Kullanıcı engellenmiş
                self?.presenter?.blockedUser()
            }
        }
    }
    
    func unblockUser(blockedUserId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("users").child(currentUserId).child("blockedUsers")
        
        ref.child(blockedUserId).removeValue {[weak self] error, _ in
            if let error = error {
                self?.presenter?.showMessage("Error removing blocked user")
            } else {
                self?.presenter?.didUnblockUser(message: "User has been unblocked.")

            }
        }
    }
    
    func deleteAccount(userId: String) {
        
        guard let currentUser = Auth.auth().currentUser, currentUser.uid == userId else {return}
        
        let postsRef = Database.database().reference().child("posts").child(userId)
        postsRef.removeValue {[weak self] error,ref  in
                if error != nil {
                    self?.presenter?.showMessage("Error")
                    return
                }
                
                // 2. Kullanıcının Kitaplarını Silme
                let booksRef = Database.database().reference().child("books").child(userId)
                booksRef.removeValue { error,ref in
                    if error != nil {
                        self?.presenter?.showMessage("Error")
                        return
                    }
                    
                    // 3. Kullanıcı Verilerini Silme
                    let userRef = Database.database().reference().child("users").child(userId)
                    userRef.removeValue { error,ref in
                        if error != nil {
                            self?.presenter?.showMessage("Error")
                            return
                        }
                        
                        currentUser.delete { error in
                            if error != nil {
                                self?.presenter?.showMessage("Error")
                            } else {
                                self?.presenter?.didDeletedUser()
                            }
                        }
                    }
                }
            }
            
    }
    
}
