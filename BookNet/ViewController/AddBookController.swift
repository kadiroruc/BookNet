//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Abdulkadir Oruç on 21.10.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddBookController: UIViewController {
    
    var selectedImage: UIImage?{
        didSet{
            self.imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    let bookNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 10
        tf.placeholder = "Kitap İsmi"
        tf.textAlignment = .center
        return tf
    }()
    let authorNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 10
        tf.placeholder = "Yazar İsmi"
        tf.textAlignment = .center
        return tf
    }()
    let shareButton : UIButton = {
       
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Kitabı Ekle", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        title = "Takas İçin Kitap Ekle"
        
        setupImageAndTextViews()
        
    }
    @objc func handleAdd(){
        self.shareButton.backgroundColor = .systemGray5
        self.shareButton.isEnabled = false
        
        guard let bookName = bookNameTextField.text, bookName.count > 0 else{return}
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5)else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("books").child(filename)
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        storageRef.putData(uploadData) {[weak self] metadata, error in
            if let error = error{
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                print("Failed to upload post image",error)
                return
            }
            storageRef.downloadURL { url, error in
                if let imageUrl = url{
                    self?.saveToDatabaseWithImageURL(imageUrl: imageUrl.absoluteString)
                }
            }
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func saveToDatabaseWithImageURL(imageUrl:String){
        guard let bookName = bookNameTextField.text else {return}
        guard let authorName = authorNameTextField.text else{return}
        guard let image = selectedImage else {return}
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let databaseRef = Database.database().reference().child("books").child(uid)
        let bookRef = databaseRef.childByAutoId()
        
        let values = ["imageUrl":imageUrl,"userId":uid, "bookName":bookName,"authorName":authorName,"imageWidth":image.size.width,"imageHeight":image.size.height,"creationDate":Date().timeIntervalSince1970] as [String:Any]
        
        bookRef.updateChildValues(values) {[weak self] error, ref in
            if let err = error{
                print("Failed to save post to db",err)
                return
            }
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                
                NotificationCenter.default.post(name: AddBookController.updateFeedNotificationName, object: nil)
            }
        }
    }
    
//    fileprivate func saveToDatabaseWithImageURL(imageUrl:String){
//        guard let caption = textField.text else {return}
//        guard let image = selectedImage else {return}
//        guard let uid = Auth.auth().currentUser?.uid else{return}
//        
//        let dictionaryValues = ["bookName": caption ,"bookImageUrl":imageUrl]
//        
//        let databaseRef = Database.database().reference().child("users").child(uid).child("books").childByAutoId()
//        databaseRef.setValue(dictionaryValues) {[weak self] error, ref in
//            if let err = error{
//                
//                print("Failed to save post to db",err)
//                return
//            }
//            DispatchQueue.main.async {
//                self?.dismiss(animated: true)
//                
//                NotificationCenter.default.post(name: AddBookController.updateFeedNotificationName, object: nil)
//            }
//        }
//    }
    
    fileprivate func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray5
        containerView.layer.cornerRadius = 20
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 400)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 220)

        
        containerView.addSubview(bookNameTextField)
        bookNameTextField.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, bottom: nil, right: imageView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        
        containerView.addSubview(authorNameTextField)
        authorNameTextField.anchor(top: bookNameTextField.bottomAnchor, left: bookNameTextField.leftAnchor, bottom: containerView.bottomAnchor, right: bookNameTextField.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(shareButton)
        shareButton.anchor(top: containerView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
}
