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
    var hasLiked: Bool = false
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
        
        Database.database().reference().child("following").child(currentUserUid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let userIdsDictionary = snapshot.value as? [String:Any] else{return}
            
            userIdsDictionary.forEach { key,value in
                Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { snapshot in
                    guard let userDictionary = snapshot.value as? [String:Any] else{return}
                    let user = UserModel(uid: key, dictionary: userDictionary)
                    
                    DispatchQueue.main.async {
                        self?.fetchPostWithUser(user: user)
                    }
                }
            }
        }
    }
    
    fileprivate func fetchPostWithUser(user: UserModel){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value) {[weak self] snapshot in
            
            
            guard let dictionaries = snapshot.value as? [String:Any] else{return}
            
            
            dictionaries.forEach { key,value in
                guard let dictionary = value as? [String:Any] else {return}

                var post = PostModel(user: user,dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else{return}
                
                self?.posts.append(post)
                self?.posts.sort(by: { p1, p2 in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                
                self?.presenter?.didFetchPosts(self?.posts ?? [])
            }
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
    

}
