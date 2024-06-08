//
//  CustomBookCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 26.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol CustomBookCellDelegate: AnyObject {
    func showAlert(from cell: CustomBookCell,message:String)
}

class CustomBookCell: UICollectionViewCell {
    
    static let identifier = "bookCell"
    
    weak var delegate: CustomBookCellDelegate?
    
    let bookImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 5
        return iv
    }()
    let bookLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .systemGray2
        return label
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("İste", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var userId:String?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews(){
        
        bookLabel.text = "TempTempTempTempTempTempTempTempTempTempTemp"
        authorLabel.text = "Temp"
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        containerView.addSubview(bookImageView)
        containerView.addSubview(bookLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(requestButton)
        
        bookImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 10, paddingRight: 0, width: 80, height: 110)
        
        bookLabel.anchor(top: containerView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: requestButton.leftAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 160, height: 35)
        
        authorLabel.anchor(top: bookLabel.bottomAnchor, left: bookLabel.leftAnchor, bottom: containerView.bottomAnchor, right: bookLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)
        
        requestButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 35)
        requestButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func requestButtonTapped(){
        requestButton.isHidden = true
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let email = Auth.auth().currentUser?.email else {return}
        guard let userId = userId else{return}
        
        
        
        didRequestedBefore(senderId: currentUserId, receiverId: userId) {[weak self] bool in
            if bool{
                
                self?.delegate?.showAlert(from: self ?? CustomBookCell(), message: "Bu kullanıcıdan daha önce kitap isteğinde bulundunuz.")
                return
            }else{
                
                let ref = Database.database().reference().child("requests").childByAutoId()
                
                let value = ["requestedBook":self?.bookLabel.text,
                             "senderId":currentUserId,
                             "receiverId": userId,
                             "status":"pending",
                             "email":email]
                
                ref.setValue(value) {[weak self] error, ref in
                    if error != nil{
                        self?.delegate?.showAlert(from: self ?? CustomBookCell(), message: "İstek gönderilirken hata oluştu.")
                        self?.requestButton.isHidden = false
                        return
                    }
                    
                    self?.delegate?.showAlert(from: self ?? CustomBookCell(), message: "İstek başarıyla gönderildi.")
                }
            }
        }

    }
    
    func didRequestedBefore(senderId:String,receiverId:String,completion: @escaping (Bool) -> Void){
    
        let ref = Database.database().reference().child("requests")
        
        ref.observeSingleEvent(of: .value) { snapshot,arg   in
            guard let dictionaries = snapshot.value as? [String:Any] else{
                completion(false)
                return
            }
            var isCompletionCalled = false
            
            dictionaries.forEach { key,value in
                guard let requestDictionaries = value as? [String:Any] else {
                    completion(false)
                    return
                }
                
                if requestDictionaries["senderId"] as! String == senderId, requestDictionaries["receiverId"] as! String == receiverId, requestDictionaries["status"] as! String == "pending"{
                    if !isCompletionCalled {
                        completion(true)
                        isCompletionCalled = true
                        return
                    }
                }
            }
            if isCompletionCalled == false{
                completion(false)
            }
        }
        
    }
    
}

