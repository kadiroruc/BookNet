//
//  ProfilePresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//


import FirebaseAuth

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    var router: ProfileRouterProtocol?
    
    var uid: String?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchUserPosts()
        if let uid = uid{
            interactor?.fetchUserProfile(for: uid)
        }else{
            interactor?.fetchUserProfile(for: Auth.auth().currentUser?.uid)
        }
    }
    
    
    func tappedLogOutButton() {
        interactor?.userLogOut()
    }

}

extension ProfilePresenter: ProfileInteractorOutputProtocol {
    
    func didFetchUserProfile(_ user: UserModel) {
        view?.hideLoading()
        view?.showUser(with: user)
    }
    
    func didFetchUserPosts(_ posts: [PostModel]) {
        view?.hideLoading()
        view?.showPosts(with: posts)
    }
    
    
    func onError() {
        view?.hideLoading()
        view?.showError()
    }
    
    func didUserLogOut() {
        router?.presentLoginScreen(from: view!)
    }
    
}

