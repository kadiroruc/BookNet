//
//  HomeInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import FirebaseAuth
import FirebaseDatabase

final class HomeInteractor {
    
    weak var presenter: HomeInteractorOutputInterface?
    
    private var posts = [PostModel]()
}

extension HomeInteractor: HomeInteractorInputInterface{
    
    func fetchPosts() {
        posts.removeAll()
        
        // fetch posts of user
        guard let currentUserUid = Auth.auth().currentUser?.uid else{return}
        
        Database.database().reference().child("users").child(currentUserUid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let userDictionary = snapshot.value as? [String:Any] else{return}
            let user = UserModel(uid: currentUserUid, dictionary: userDictionary)
            
            DispatchQueue.main.async {
                
                self?.fetchPostWithUser(user: user)
            }
        }
        
        
        //Fetch following user ids
        
        fetchBlockedUsers { [weak self] blockedUserIds in
            Database.database().reference().child("following").child(currentUserUid).observeSingleEvent(of: .value) {[weak self] snapshot in
                guard let userIdsDictionary = snapshot.value as? [String:Any] else{return}
                
                userIdsDictionary.forEach { key,value in
                    
                    Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { snapshot in
                        guard let userDictionary = snapshot.value as? [String:Any] else{return}
                        let user = UserModel(uid: key, dictionary: userDictionary)
                        
                        if !(blockedUserIds.contains(key)){
                            DispatchQueue.main.async {
                                self?.fetchPostWithUser(user: user)
                            }
                        }

                    }
                }
            }
        }
        

    }
    
    fileprivate func fetchPostWithUser(user: UserModel){
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        let sixDaysAgoTimestamp = Date().timeIntervalSince1970 - (5 * 24 * 60 * 60)
        
        ref.queryOrdered(byChild: "creationDate").queryStarting(atValue: sixDaysAgoTimestamp).observeSingleEvent(of: .value) {[weak self] snapshot in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {
                    self?.presenter?.didFailToFetchPosts(with: "No Posts Found")
                    return
                }
                
                dictionaries.forEach { key, value in
                    guard let dictionary = value as? [String: Any] else { return }
                    
                    let reportedCount = dictionary["reported"] as? Int ?? 0
                    
                    if reportedCount > 20 {
                        return
                    }

                    var post = PostModel(user: user, dictionary: dictionary)
                    post.id = key
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }

                    self?.posts.append(post)
                    self?.posts.sort(by: { p1, p2 in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self?.presenter?.didFetchPosts(self?.posts ?? [])
                }
        }
        if self.posts.isEmpty == true {
            self.presenter?.didFailToFetchPosts(with: "No Posts Found")
        }
    }
    
    func fetchBlockedUsers(completion: @escaping ([String]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users").child(currentUserId).child("blockedUsers")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var blockedUserIds: [String] = []
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let userId = child.key
                blockedUserIds.append(userId)
            }
            
            completion(blockedUserIds)
        }
    }
    
    func addlikeToPost(userIdOfPost: String, postId: String, userIdOfLike: String, index: Int) {
        
        let postRef = Database.database().reference().child("posts").child(userIdOfPost).child(postId).child("likes")
        
        // Yeni beğeni (like) eklemek için
        postRef.observeSingleEvent(of: .value) {[weak self] snapshot in
            if var likes = snapshot.value as? [String] {
                // Likes dizisine yeni userId'yi ekleyin
                if !likes.contains(userIdOfLike){
                    likes.append(userIdOfLike)
                    postRef.setValue(likes)

                }else{
                    if let index = likes.firstIndex(of: userIdOfLike){
                        likes.remove(at: index)
                        postRef.setValue(likes)
                    }
                }
            } else {
                // Likes dizisi yoksa, yeni bir dizi oluşturun ve ilk userId'yi ekleyin
                postRef.setValue([userIdOfLike])
            }
        }
    }
    
    func reportPost(postId: String, userId: String) {
        let ref = Database.database().reference().child("posts").child(userId).child(postId)
        
        ref.child("reported").observeSingleEvent(of: .value) {[weak self] snapshot in
            
            if let reported = snapshot.value as? Bool {
                if reported == false {
                    
                    ref.child("reported").setValue(true)
                    ref.child("reports").child(Auth.auth().currentUser?.uid ?? "unknown").setValue(true)
                    self?.presenter?.showMessage("Report Submitted, thank you for your report.")
                } else {
                    self?.presenter?.showMessage("This post has already been reported.")
                }
            } else {
                
                ref.child("reported").setValue(true)
                ref.child("reports").child(Auth.auth().currentUser?.uid ?? "unknown").setValue(true)
                self?.presenter?.showMessage("Report Submitted, thank you for your report.")
            }
        }
    }
    
    func blockUser(userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(currentUserId).child("blockedUsers").child(userId)
        
        ref.setValue(true) {[weak self] error, _ in
            if error != nil {
                self?.presenter?.showMessage("Failed to block user.")
            } else {
                self?.presenter?.showMessage("You have blocked the user. You won't see posts of this user anymore.")
            }
        }
    }


}
