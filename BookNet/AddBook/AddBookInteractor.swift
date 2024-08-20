//
//  AddBookInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

final class AddBookInteractor {
    weak var presenter: AddBookInteractorOutputInterface?
}

// MARK: - Extensions -

extension AddBookInteractor: AddBookInteractorInterface {
    func uploadBook(bookName: String, authorName: String, image: UIImage) {
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5)else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("books").child(filename)
        
        storageRef.putData(uploadData) {[weak self] metadata, error in
            if let error = error{
                DispatchQueue.main.async {
                    self?.presenter?.didFailToUploadBook(error.localizedDescription)
                }
                return
            }
            storageRef.downloadURL { url, error in
                if let imageUrl = url{
                    
                    guard let uid = Auth.auth().currentUser?.uid else{return}
                    
                    let databaseRef = Database.database().reference().child("books").child(uid)
                    let bookRef = databaseRef.childByAutoId()
                    
                    let values = ["imageUrl":imageUrl.absoluteString,"userId":uid, "bookName":bookName,"authorName":authorName,"imageWidth":image.size.width,"imageHeight":image.size.height,"creationDate":Date().timeIntervalSince1970] as [String:Any]
                    
                    bookRef.updateChildValues(values) {[weak self] error, ref in
                        if let error = error{
                            DispatchQueue.main.async {
                                self?.presenter?.didFailToUploadBook(error.localizedDescription)
                            }
                            return
                        }else{
                            DispatchQueue.main.async {
                                self?.presenter?.didUploadBook()
                            }
                        }
                    }
                }
            }
        }
    }
}
