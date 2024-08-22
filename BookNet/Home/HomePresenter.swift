//
//  HomePresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import UIKit
import CoreGraphics
import FirebaseAuth

final class HomePresenter: HomePresenterInterface {

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInputInterface
    private let wireframe: HomeWireframeInterface
    
    private var posts = [PostModel]()

    init(view: HomeViewInterface, interactor: HomeInteractorInputInterface, wireframe: HomeWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }

    func viewDidLoad() {
        interactor.fetchPosts()
    }
    
    func handleRefresh() {
        posts.removeAll()
        view.reloadData()
        interactor.fetchPosts()
    }

    func numberOfPosts() -> Int {
        return posts.count
    }

    func configureCell(_ cell: CustomPostCell, for index: Int) {
        let post = posts[index]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(gray: 0, alpha: 1)
        
        cell.bookLabel.text = post.bookName
        cell.bookImageView.loadImage(urlString: post.bookImageUrl)
        cell.postLabel.text = post.postText
        cell.postDescriptionLabel.text = post.autherName
        cell.dateLabel.text = post.creationDate.timeAgoDisplay()
        cell.profileImageView.loadImage(urlString: post.user.profileImageUrl)
        cell.usernameLabel.text = post.user.username
        if let likes = post.likes{
            cell.likeCountLabel.text = "\(likes.count)"
            
            if let uid = Auth.auth().currentUser?.uid{
                if likes.contains(uid){
                    cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }else{
                    cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }

        }
    }

    func didSelectPost(at index: Int) {
        let userId = posts[index].user.uid
        wireframe.navigateToProfile(with: userId)
    }
    
    func likeButtonTapped(for index: Int) {
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        if posts[index].postId != ""{
            interactor.addlikeToPost(userIdOfPost: posts[index].user.uid, postId: posts[index].postId, userIdOfLike: currentUserId,index: index)
        }
    }
}

extension HomePresenter: HomeInteractorOutputInterface {
    func didFailToFetchPosts(with message: String) {
        view.endRefreshing()
        //view.showMessage(message: message)
    }
    
    func didFetchPosts(_ posts: [PostModel]) {
        self.posts = posts
        view.reloadData()
        view.endRefreshing()
    }
}

