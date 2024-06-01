//
//  SearchBookCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.05.2024.
//

import UIKit

class SearchBookCell: UICollectionViewCell{
    
    var user: User?{
        didSet{
//            usernameLabel.text = user?.username
//            guard let profileImageUrl = user?.profileImageUrl else {return}
//            
//            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    var book: Book?{
        didSet{
            bookNameLabel.text = book?.bookName
            guard let bookImageUrl = book?.imageUrl else {return}
            
            bookImageView.loadImage(urlString: bookImageUrl)
        }
    }
    
    let bookImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
//    var usernameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Username"
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        return label
//    }()
    var bookNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bookImageView)
        addSubview(bookNameLabel)
        addSubview(accessoryImageView)
        
        bookImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        bookImageView.layer.cornerRadius = 50/2
        bookImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bookNameLabel.anchor(top: nil, left: bookImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        bookNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        accessoryImageView.anchor(top: nil, left: bookNameLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        accessoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let separatorView =  UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: bookNameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

