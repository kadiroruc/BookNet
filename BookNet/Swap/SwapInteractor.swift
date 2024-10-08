//
//  SwapInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import Foundation
import FirebaseDatabase

final class SwapInteractor {
    
    weak var presenter: SwapInteractorOutputInterface?
}

// MARK: - Extensions -

extension SwapInteractor: SwapInteractorInterface {
    
    func fetchRequests(forUserId userId: String) {
        
        let databaseRef = Database.database().reference().child("requests")
        let query = databaseRef.queryOrdered(byChild: "receiverId").queryEqual(toValue: userId)
        
        query.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            var fetchedRequests = [RequestModel]()
            
            if let requests = snapshot.value as? [String: Any] {
                for (_, value) in requests {
                    if let valueDictionary = value as? [String: Any] {
                        let request = RequestModel(dictionary: valueDictionary)
                        fetchedRequests.append(request)
                    }
                }
            }
            self.presenter?.didFetchRequests(fetchedRequests)
        }
    }
    func fetchUserOfRequest(request: RequestModel, completion: @escaping (UserModel?) -> Void) {
        
        let userId = request.senderId
        
        let ref = Database.database().reference().child("users").child(userId)
        
        ref.observeSingleEvent(of: .value) {[weak self] snapshot  in
            if let dictionary = snapshot.value as? [String:Any] {
                let user = UserModel(uid: userId, dictionary: dictionary)
                completion(user)
            } else {
                
            }
            
        }
    }
    
    func acceptRequest(_ request: RequestModel) {
        let requestId = request.id
        
        let ref = Database.database().reference().child("requests").child(requestId)
        ref.updateChildValues(["status": "accepted"]) {[weak self] error, _ in
            if let error = error {
                DispatchQueue.main.async {
                    self?.presenter?.didFail(error.localizedDescription)
                }
                return
            }
            DispatchQueue.main.async {
                self?.presenter?.didAcceptRequest()
            }
        }
    }
    
    func cancelRequest(_ request: RequestModel, index: Int) {
        let requestId = request.id
        
        let ref = Database.database().reference().child("requests").child(requestId)
        
        ref.removeValue {[weak self] error, _ in
            if error != nil {
                DispatchQueue.main.async {
                    self?.presenter?.didFail("There was an error rejecting a book request.")
                }
                return
            }
            
            // İstek başarıyla silindi
            DispatchQueue.main.async {
                self?.presenter?.didCancelRequest(index: index)
            }
        }
    }
}
