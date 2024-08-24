//
//  SwapInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

protocol SwapWireframeInterface: WireframeInterface {
    func navigateToProfile(userId: String)
}

protocol SwapViewInterface: ViewInterface {
    func reloadData()
    func showMessage(_ message: String)
    func showLoading()
    func hideLoading()
    
}

protocol SwapPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func viewDidDisappear()
    func viewWillAppear()
    func numberOfItems() -> Int
    func request(at index: Int) -> RequestModel
    func configureCell(_ cell: CustomRequestsCell, for indexPath: IndexPath, request: RequestModel)
    
}

protocol SwapInteractorInterface: InteractorInterface {
    func fetchRequests(forUserId userId: String)
    func fetchUserOfRequest(request: RequestModel, completion: @escaping (UserModel?) -> Void)
    func acceptRequest(_ request: RequestModel)
    func cancelRequest(_ request: RequestModel, index: Int)
}

protocol SwapInteractorOutputInterface: PresenterInterface {
    func didFetchRequests(_ requests: [RequestModel])
    func didAcceptRequest()
    func didCancelRequest(index: Int)
    func didFail(_ error: String)
}
