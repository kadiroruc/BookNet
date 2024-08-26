//
//  HomeInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import UIKit

protocol HomeViewInterface: AnyObject {
    func reloadData()
    func endRefreshing()
    func showMessage(message: String)
}

protocol HomePresenterInterface: AnyObject {
    func viewDidLoad()
    func handleRefresh()
    func numberOfPosts() -> Int
    func configureCell(_ cell: CustomPostCell, for index: Int)
    func didSelectPost(at index: Int)
    func likeButtonTapped(for index: Int)
    func reportPost(index: Int)
    func blockUser(index: Int)
}

protocol HomeInteractorInputInterface: AnyObject {
    func fetchPosts()
    func addlikeToPost(userIdOfPost: String, postId: String, userIdOfLike: String, index: Int)
    func reportPost(postId: String, userId: String)
    func blockUser(userId: String)
}

protocol HomeInteractorOutputInterface: AnyObject {
    func didFetchPosts(_ posts: [PostModel])
    func didFailToFetchPosts(with message: String)
    func showMessage(_ message: String)
}

protocol HomeWireframeInterface: AnyObject {
    func navigateToProfile(with userId: String)
}

