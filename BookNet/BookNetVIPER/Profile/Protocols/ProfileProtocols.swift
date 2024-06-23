//
//  ProfileViewProtocol.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showPosts(with posts: [PostModel])
    
    func showUser(with user: UserModel)
    
    func showError()
    
    func showLoading()
    
    func hideLoading()
}

protocol ProfileRouterProtocol: AnyObject {
    static func createProfileModule(with uid : String?) -> UIViewController
    // PRESENTER -> WIREFRAME
    func presentLoginScreen(from view: ProfileViewProtocol)
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    var interactor: ProfileInteractorInputProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
    var uid: String? {get set}
    
    // VIEW -> PRESENTER
    func viewDidLoad()
//    func showPostDetail(forPost post: PostModel)
    func tappedLogOutButton()
}

protocol ProfileInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func didFetchUserProfile(_ user: UserModel)
    func didFetchUserPosts(_ posts: [PostModel])
    func onError()
    func didUserLogOut()
}

protocol ProfileInteractorInputProtocol: AnyObject {
    var presenter: ProfileInteractorOutputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func fetchUserProfile(for uid: String?)
    func fetchUserPosts()
    func userLogOut()
}


