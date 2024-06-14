//
//  HomeViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 12.06.2024.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName , object: nil)
        

        collectionView.register(CustomPostCell.self, forCellWithReuseIdentifier: CustomPostCell.identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        navigationItem.title = "BookNet"
        navigationItem.titleView?.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        fetchAllPosts()

    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    @objc func handleRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserIds()
    }
        
    fileprivate func fetchFollowingUserIds(){
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("following").child(currentUserUid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let userIdsDictionary = snapshot.value as? [String:Any] else{return}
            
            userIdsDictionary.forEach { key,value in
                Database.fetchUserWithUID(uid: key) { user in
                    self?.fetchPostWithUser(user: user)
                }
            }
        }
    }
    
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostWithUser(user: User){
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value) {[weak self] snapshot in
            
            self?.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String:Any] else{return}
            
            
            dictionaries.forEach { key,value in
                guard let dictionary = value as? [String:Any] else {return}

                var post = Post(user: user,dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else{return}
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { snapshot in
                    
                    
                    if let value = snapshot.value as? Int, value == 1{
                        post.hasLiked = true
                    }else{
                        post.hasLiked = false
                    }
                    
                }
                self?.posts.append(post)
                self?.posts.sort(by: { p1, p2 in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 300
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPostCell.identifier, for: indexPath) as! CustomPostCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(gray: 0, alpha: 1)
        
        if posts.count > 0 {
            cell.bookLabel.text = posts[indexPath.item].bookName
            cell.bookImageView.loadImage(urlString: posts[indexPath.item].bookImageUrl)
            cell.postLabel.text = posts[indexPath.item].postText
            cell.postDescriptionLabel.text = posts[indexPath.item].autherName
            cell.dateLabel.text = posts[indexPath.item].creationDate.timeAgoDisplay()
            cell.profileImageView.loadImage(urlString: posts[indexPath.item].user.profileImageUrl)
            cell.usernameLabel.text = posts[indexPath.item].user.username
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profileController = ProfileViewController()
        profileController.userId = posts[indexPath.item].user.uid
        profileController.titleLabel.subviews.first?.isHidden = true
        profileController.followButton.isHidden = false
        navigationController?.pushViewController(profileController, animated: true)
    }
    
//    func didTapComment(post: Post) {
//        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
//        commentsController.post = post
//        navigationController?.pushViewController(commentsController, animated: true)
//    }
    
//    func didLike(for cell: HomePostCell) {
//        guard let indexpath = collectionView.indexPath(for: cell) else {return}
//        var post = self.posts[indexpath.item]
//        guard let postId = post.id else {return}
//        guard let uid = Auth.auth().currentUser?.uid else{return}
//        
//        let values = [uid:post.hasLiked == true ? 0 : 1]
//        Database.database().reference().child("likes").child(postId).updateChildValues(values) { error, ref in
//            if let err = error{
//                print(err)
//                return
//            }
//            post.hasLiked = !post.hasLiked
//            self.posts[indexpath.item] = post
//            self.collectionView.reloadItems(at: [indexpath])
//        }
//    }
    

}

