//
//  CustomPostCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 25.04.2024.
//

import UIKit

protocol CustomPostCellLikeDelegate: AnyObject{
    func likeButtonTapped(in cell: CustomPostCell)
}
protocol CustomPostCellTrashDelegate: AnyObject{
    func trashButtonTapped(in cell: CustomPostCell)
}
protocol CustomPostCellReportAndBlockDelegate: AnyObject {
    func reportButtonTapped(in cell: CustomPostCell)
    func blockButtonTapped(in cell: CustomPostCell)
    
}
class CustomPostCell: UICollectionViewCell {
    
    static let identifier = "postCell"
    
    weak var likeDelegate: CustomPostCellLikeDelegate?
    weak var trashDelegate: CustomPostCellTrashDelegate?
    weak var reportAndBlockDelegate: CustomPostCellReportAndBlockDelegate?
    
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
    
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
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
        
        if likeButton.imageView?.image == UIImage(systemName: "heart"){
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            if var count = Int(likeCountLabel.text!){
                count += 1
                likeCountLabel.text = "\(count)"
            }
        }else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            if var count = Int(likeCountLabel.text!){
                count -= 1
                likeCountLabel.text = "\(count)"
            }
        }
        
        self.likeDelegate?.likeButtonTapped(in: self)
    }
    
    @objc func trashButtonTapped(){
        self.trashDelegate?.trashButtonTapped(in: self)
    }
    
    @objc func menuButtonTapped(){
        let menu = UIMenu(title: "Post Options", children: [
            UIAction(title: "Report the post", handler: { _ in
                self.reportAndBlockDelegate?.reportButtonTapped(in: self)
            }),
            UIAction(title: "Block The User", handler: { _ in
                self.reportAndBlockDelegate?.blockButtonTapped(in: self)
            })
        ])
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    func setViews(){
        
        layer.cornerRadius = 15
        clipsToBounds = true

        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        headerView.addSubview(profileImageView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(menuButton)
        
        
        profileImageView.anchor(top: headerView.centerYAnchor, left: headerView.leftAnchor, bottom: nil, right: nil, paddingTop: -20, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        usernameLabel.anchor(top: headerView.centerYAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 70, height: 30)
        dateLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 50)
        dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        menuButton.anchor(top: nil, left: dateLabel.rightAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        menuButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        
        let midView = UIView()
        midView.backgroundColor = UIColor.rgb(red: 252, green: 217, blue: 124)
        midView.addSubview(postLabel)
        midView.addSubview(postDescriptionLabel)
        
        
        postLabel.anchor(top: midView.topAnchor, left: midView.leftAnchor, bottom: nil, right: midView.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        postDescriptionLabel.anchor(top: postLabel.bottomAnchor, left: midView.leftAnchor, bottom: midView.bottomAnchor, right: midView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
        
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.rgb(red: 254, green: 245, blue: 215)
        footerView.addSubview(bookImageView)
        footerView.addSubview(bookLabel)
        footerView.addSubview(likeButton)
        footerView.addSubview(likeCountLabel)
        footerView.addSubview(trashButton)
        
        bookImageView.anchor(top: footerView.topAnchor, left: footerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 40, height: 60)
        bookLabel.anchor(top: bookImageView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
        likeButton.anchor(top: nil, left: bookImageView.leftAnchor, bottom: footerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        likeCountLabel.anchor(top: likeButton.centerYAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: -9, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        trashButton.anchor(top: likeButton.centerYAnchor, left: nil, bottom: nil, right: footerView.rightAnchor, paddingTop: -9, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
        addSubview(midView)
        midView.anchor(top: headerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        addSubview(footerView)
        footerView.anchor(top: midView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 120)
        
        
    }
}
