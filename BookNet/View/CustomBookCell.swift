//
//  CustomBookCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 26.05.2024.
//

import UIKit

class CustomBookCell: UICollectionViewCell {
    
    static let identifier = "bookCell"
    
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
        
        bookImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 30, paddingBottom: 10, paddingRight: 0, width: 80, height: 110)
        
        bookLabel.anchor(top: containerView.topAnchor, left: bookImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 30, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        authorLabel.anchor(top: bookLabel.bottomAnchor, left: bookLabel.leftAnchor, bottom: containerView.bottomAnchor, right: bookLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    
}

