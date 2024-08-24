//
//  PostCollectionViewCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCell"
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        return label
    }()
    let postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    let bookImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .gray
        return iv
    }()
    let bookLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let favoriteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        return button
    }()

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setViews()
        
    }
    
    func set(forPost post: PostModel) {
        self.usernameLabel.text = post.user.username
        self.profileImageView.loadImage(urlString: post.user.profileImageUrl)
        self.bookImageView.loadImage(urlString: post.bookImageUrl)
        self.bookLabel.text = post.bookName
        self.postLabel.text = "\"\(post.postText)\""
        self.dateLabel.text = post.creationDate.timeAgoDisplay()
        self.postDescriptionLabel.text = post.autherName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews(){
        
        layer.cornerRadius = 15
        clipsToBounds = true

        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        headerView.addSubview(profileImageView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(dateLabel)
        
        
        profileImageView.anchor(top: headerView.centerYAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: -20, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        usernameLabel.anchor(top: headerView.centerYAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 70, height: 30)
        dateLabel.anchor(top: headerView.centerYAnchor, left: nil, bottom: nil, right: headerView.rightAnchor, paddingTop: -15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 80, height: 30)
        
        
        let midView = UIView()
        midView.backgroundColor = UIColor.rgb(red: 252, green: 217, blue: 124)
        midView.addSubview(postLabel)
        midView.addSubview(postDescriptionLabel)
        
        
        postLabel.anchor(top: midView.topAnchor, left: midView.leftAnchor, bottom: nil, right: midView.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        postDescriptionLabel.anchor(top: postLabel.bottomAnchor, left: midView.leftAnchor, bottom: midView.bottomAnchor, right: midView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        footerView.addSubview(bookImageView)
        footerView.addSubview(bookLabel)
        footerView.addSubview(favoriteButton)
        footerView.addSubview(favoriteCountLabel)
//        footerView.addSubview(commentButton)
        
        
        bookImageView.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 40, height: 60)
        bookLabel.anchor(top: bookImageView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
        favoriteButton.anchor(top: nil, left: bookImageView.leftAnchor, bottom: footerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        favoriteCountLabel.anchor(top: favoriteButton.centerYAnchor, left: favoriteButton.rightAnchor, bottom: nil, right: nil, paddingTop: -9, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        commentButton.anchor(top: nil, left: favoriteCountLabel.rightAnchor, bottom: footerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        
        
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
        addSubview(midView)
        midView.anchor(top: headerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        addSubview(footerView)
        footerView.anchor(top: midView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 120)
        
        
    }
}

