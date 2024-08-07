//
//  SwapViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.06.2024.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class SwapCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var requests = [Request]()
    
    override func viewDidLoad() {
        
        
        
        collectionView.register(CustomRequestsCell.self, forCellWithReuseIdentifier: "cellId")
        
//        fetchRequestsOfUser()
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.requests.removeAll(keepingCapacity: true)
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requests.removeAll(keepingCapacity: true)
        fetchRequestsOfUser()
        self.collectionView.reloadData()
    }
    
    func fetchRequestsOfUser(){
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        fetchRequests(forUserId: userId) { requests in
            
            for (_,value) in requests{
                let valueDictionary = value as! [String:Any]
                let request = Request(dictionary: valueDictionary)
                
                self.requests.append(request)
                
                
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
    func fetchRequests(forUserId userId: String, completion: @escaping ([String: Any]) -> Void){
        
        let databaseRef = Database.database().reference().child("requests")
        let query = databaseRef.queryOrdered(byChild: "receiverId").queryEqual(toValue: userId)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            guard let requests = snapshot.value as? [String: Any] else {
                completion([:])
                return
            }
            completion(requests)
        }
    }
    
    func userOfRequest(request: Request, completion: @escaping (UserModel?) -> Void){
        let userId = request.senderId
        
        let ref = Database.database().reference().child("users").child(userId)
        
        ref.observeSingleEvent(of: .value) { snapshot  in
            if let dictionary = snapshot.value as? [String:Any] {
                let user = UserModel(uid: userId, dictionary: dictionary)
                completion(user)
            } else {
                completion(nil)
            }
            
        }
    }
    
    func fetchUserId(for username: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            for (userId, userDetails) in users {
                if let userUsername = userDetails["username"] as? String, userUsername == username {
                    completion(userId)
                    return
                }
            }
            completion(nil)
        }
    }

    
    //MARK: - CollectionView Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomRequestsCell
    
        cell.delegate = self
        cell.indexPath = indexPath
        
        userOfRequest(request: requests[indexPath.item]) { user in
            DispatchQueue.main.async {

                
                if let user = user{
                
                    cell.usernameLabel.text = user.username
                    
                    cell.profileImageView.loadImage(urlString: user.profileImageUrl)
                    
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 20 // Hücrenin genişliği, collection view'nin genişliği kadar
        let cellHeight: CGFloat = 400 // Hücrenin yüksekliği
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10 // Sağdan ve soldan boşluk miktarı
        
        return UIEdgeInsets(top: 10, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(-60)
    }
    
    
}

//MARK: - TappedButtons

extension SwapCollectionViewController: CustomRequestsCellDelegate{
    
    func tappedCancelButton(at indexPath: IndexPath) {
        let request = requests[indexPath.item]
        let requestId = request.id
        
        let ref = Database.database().reference().child("requests").child(requestId)
        
        ref.removeValue {[weak self] error, _ in
            if error != nil {
                DispatchQueue.main.async {
                    self?.showAlert(title: nil, message: "Kitap isteği reddelirken hata oluştu.")
                }
                return
            }
            
            // İstek başarıyla silindi
            DispatchQueue.main.async {
                self?.showAlert(title: nil, message: "Kitap isteği reddedildi. ")
                self?.requests.remove(at: indexPath.item)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func tappedAcceptButton(at indexPath: IndexPath) {
        let request = requests[indexPath.item]
        let requestId = request.id
        
        let ref = Database.database().reference().child("requests").child(requestId)
        ref.updateChildValues(["status": "accepted"]) {[weak self] error, _ in
            if let error = error {
                
                DispatchQueue.main.async {
                    self?.showAlert(title: nil, message: "Kitap isteği onaylanırken hata oluştu.")
                }
                return
            }
            DispatchQueue.main.async {
                self?.showAlert(title: nil, message: "Kitap isteği onaylandı. Kullanıcının kitaplarından birini seçebilirsiniz. ")
            }
        }
    }
    
    
    
    func tappedSeeProfileButton(username: String) {
        
//        let userId = fetchUserId(for: username) { userId in
//            if let userId = userId{
//                let profileController = ProfileViewController()
//                profileController.userId = userId
//                profileController.titleLabel.subviews.first?.isHidden = true
//                profileController.followButton.isHidden = false
//                self.navigationController?.pushViewController(profileController, animated: true)
//            }
//        }
    }
    

    
    
}

//struct ViewControllerPreview: PreviewProvider{
//    static var previews: some View {
//        VCPreview{ SwapCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()) }
//    }
//}



