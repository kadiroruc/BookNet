//
//  CustomPostCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 25.04.2024.
//

import UIKit

protocol CustomPostCellDelegate: AnyObject{
    func likeButtonTapped(in cell: CustomPostCell)
}

class CustomPostCell: UICollectionViewCell {
    
    static let identifier = "postCell"
    
    weak var delegate: CustomPostCellDelegate?
    
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
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeButtonTapped(){
        self.delegate?.likeButtonTapped(in: self)
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
        dateLabel.anchor(top: headerView.centerYAnchor, left: nil, bottom: nil, right: headerView.rightAnchor, paddingTop: -15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 80, height: 50)
        
        
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
        footerView.addSubview(likeButton)
        footerView.addSubview(likeCountLabel)
        
        
        bookImageView.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 40, height: 60)
        bookLabel.anchor(top: bookImageView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
        likeButton.anchor(top: nil, left: bookImageView.leftAnchor, bottom: footerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        likeCountLabel.anchor(top: likeButton.centerYAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: -9, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
        addSubview(midView)
        midView.anchor(top: headerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        addSubview(footerView)
        footerView.anchor(top: midView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 120)
        
        
    }
}
