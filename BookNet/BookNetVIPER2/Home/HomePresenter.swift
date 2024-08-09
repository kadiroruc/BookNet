//
//  HomePresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import CoreGraphics

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
    }

    func didSelectPost(at index: Int) {
        let userId = posts[index].user.uid
        wireframe.navigateToProfile(with: userId)
    }
}

extension HomePresenter: HomeInteractorOutputInterface {
    func didFailToFetchPosts(with error: any Error) {
        
    }
    
    func didFetchPosts(_ posts: [PostModel]) {
        self.posts = posts
        view.reloadData()
        view.endRefreshing()
    }
}