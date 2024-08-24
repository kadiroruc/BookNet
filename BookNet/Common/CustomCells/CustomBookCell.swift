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
    func requestButtonTapped(senderId: String, receiverId: String, email:String,requestedBook:String)
}

protocol CustomBookCellTrashDelegate: AnyObject{
    func trashButtonTapped(in cell: CustomBookCell)
}

class CustomBookCell: UICollectionViewCell {
    
    static let identifier = "bookCell"
    
    weak var delegate: CustomBookCellDelegate?
    weak var trashDelegate: CustomBookCellTrashDelegate?
    
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
        button.setTitle("Request", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        button.tintColor = .black
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
    
    @objc func trashButtonTapped(){
        self.trashDelegate?.trashButtonTapped(in: self)
    }
    
    func setViews(){
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        containerView.addSubview(bookImageView)
        containerView.addSubview(bookLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(requestButton)
        containerView.addSubview(trashButton)
        
        bookImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 10, paddingRight: 0, width: 80, height: 110)
        
        bookLabel.anchor(top: containerView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: requestButton.leftAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 160, height: 35)
        
        authorLabel.anchor(top: bookLabel.bottomAnchor, left: bookLabel.leftAnchor, bottom: containerView.bottomAnchor, right: bookLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)
        
        requestButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 35)
        requestButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        trashButton.anchor(top: nil, left: nil, bottom: nil, right: requestButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        trashButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func requestButtonTapped(){
        self.requestButton.isHidden = true
        
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let email = Auth.auth().currentUser?.email else {return}
        guard let userId = userId else{return}
        
        delegate?.requestButtonTapped(senderId: currentUserId, receiverId: userId, email: email,requestedBook: self.bookLabel.text!)
        

    }
    
}

