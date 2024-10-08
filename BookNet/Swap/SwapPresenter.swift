//
//  SwapPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
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
        
        interactor.fetchUserOfRequest(request: request) { [weak self] user in
            guard let self = self, let user = user else { return }
            
            self.userOfRequest = user
            cell.usernameLabel.text = user.username
            
            DispatchQueue.global().async {
                var image: UIImage?
                
                if let url = URL(string: user.profileImageUrl), let imageData = try? Data(contentsOf: url) {
                    image = UIImage(data: imageData)
                }
                
                DispatchQueue.main.async {
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
                        //cell.subviews.first?.backgroundColor = .green
                        cell.usernameLabel.text = "\(cell.usernameLabel.text!)  -> You accepted"
                        cell.usernameLabel.textColor = UIColor.rgb(red: 0, green: 160, blue: 0)
                    }
                    
                    if indexPath.item == self.requests.count - 1 {
                        self.view.hideLoading()
                    }
                }
            }
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
    
    func didFetchRequests(_ requests: [RequestModel]) {
        self.requests = requests
        view.reloadData()
        view.hideLoading()
    }
    
    func didFail(_ error: String) {
        view.hideLoading()
        view.showMessage(error)
        view.hideLoading()
    }
    
    func didAcceptRequest() {
        view.hideLoading()
        view.showMessage("Book request approved. You can select one of the user's books. ")
    }
    
    func didCancelRequest(index: Int) {
        view.hideLoading()
        view.showMessage("Book request successfully deleted")
        requests.remove(at: index)
        view.reloadData()
    }
}

extension SwapPresenter: CustomRequestsCellDelegate{
    func tappedSeeProfileButton(at indexPath: IndexPath) {
        
        interactor.fetchUserOfRequest(request: requests[indexPath.item]) { user in
            if let user = user{
                self.wireframe.navigateToProfile(userId: user.uid)
            }
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
