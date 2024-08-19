//
//  PhotoSelectorCell.swift
//  InstagramClone
//
//  Created by Abdulkadir Oruç on 21.10.2023.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell{
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 3.0 : 0.0
            self.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
            self.layer.cornerRadius = isSelected ? 5.0 : 0.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
