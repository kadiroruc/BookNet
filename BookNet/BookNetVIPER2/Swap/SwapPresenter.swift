//
//  SwapPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Firebase

final class SwapPresenter {
    
    // MARK: - Private properties -

    private unowned let view: SwapViewInterface
    private let interactor: SwapInteractorInterface
    private let wireframe: SwapWireframeInterface
    
    private var requests: [RequestModel] = []
    private var userOfRequest: UserModel?

    // MARK: - Lifecycle -

    init(view: SwapViewInterface, interactor: SwapInteractorInterface, wireframe: SwapWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SwapPresenter: SwapPresenterInterface {
    
    func configureCell(_ cell: CustomRequestsCell, for indexPath: IndexPath, request: RequestModel) {
        cell.delegate = self
        cell.indexPath = indexPath
        
        let group = DispatchGroup()


        group.enter()
            
        self.interactor.fetchUserOfRequest(request: request)
        group.leave()

        // Grup içindeki tüm görevlerin bitmesini bekle
        group.notify(queue: .main) {
            
            if let user = self.userOfRequest {

                cell.usernameLabel.text = user.username
                
                let secondGroup = DispatchGroup()
                secondGroup.enter()
                
                if let url = URL(string: user.profileImageUrl), let imageData = try? Data(contentsOf: url) {
                    let image = UIImage(data: imageData)
                    secondGroup.leave()
                    
                    secondGroup.notify(queue: .main) {
                        if cell.usernameLabel.text == user.username {
                            cell.profileImageView.image = image
                        }
                        
                        let requestedBook = self.requests[indexPath.item].requestedBook
                        cell.requestedBookLabel.text = "Requested Book  ->  '\(requestedBook)'"
                        
                        let email = self.requests[indexPath.item].email
                        cell.emailLabel.text = "Email  ->  '\(email)'"
                        
                        let status = self.requests[indexPath.item].status
                        
                        if status == "accepted" {
                            cell.acceptButton.isEnabled = false
                        }
                        
                    }
                }
                

            }
            
        }
 
        if indexPath.item == requests.count - 1{
            view.hideLoading()
        }
        
    }
    
    
    func viewDidLoad() {
    }
    
    func viewDidDisappear() {
        self.requests.removeAll()
        view.reloadData()
    }
    
    func viewWillAppear() {
        self.requests.removeAll()
        view.showLoading()
        guard let uid = Auth.auth().currentUser?.uid else{return}
        interactor.fetchRequests(forUserId: uid)
    }
    
    func numberOfItems() -> Int {
        return requests.count
    }
    
    func request(at index: Int) -> RequestModel {
        return requests[index]
    }
}

// MARK: - Interactor Output

extension SwapPresenter: SwapInteractorOutputInterface {
    func didFetchUserOfRequest(_ user: UserModel) {
        self.userOfRequest = user
    }
    
    func didFetchRequests(_ requests: [RequestModel]) {
        self.requests = requests
        view.reloadData()
    }
    
    func didFail(_ error: String) {
        view.hideLoading()
        view.showMessage(error)
    }
    
    func didAcceptRequest() {
        view.hideLoading()
        view.showMessage("Kitap isteği onaylandı. Kullanıcının kitaplarından birini seçebilirsiniz. ")
    }
    
    func didCancelRequest(index: Int) {
        view.hideLoading()
        view.showMessage("Kitap isteği başarıyla silindi")
        requests.remove(at: index)
        view.reloadData()
    }
}

extension SwapPresenter: CustomRequestsCellDelegate{
    func tappedSeeProfileButton(at indexPath: IndexPath) {
        print("sdasdfas")
        interactor.fetchUserOfRequest(request: requests[indexPath.item])
        
        if let user = userOfRequest{
            wireframe.navigateToProfile(userId: user.uid)
        }
    }
    
    func tappedCancelButton(at indexPath: IndexPath) {
        view.showLoading()
        interactor.cancelRequest(requests[indexPath.item], index: indexPath.item)
    }
    
    func tappedAcceptButton(at indexPath: IndexPath) {
        view.showLoading()
        interactor.acceptRequest(requests[indexPath.item])
    }
    
    
}
