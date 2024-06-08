//
//  CustomSwapCell.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.06.2024.
//

import UIKit
import SwiftUI

protocol CustomRequestsCellDelegate: AnyObject{
    func tappedSeeProfileButton(username:String)
}

class CustomRequestsCell: UICollectionViewCell {
    
    weak var delegate: CustomRequestsCellDelegate?
    
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        return lb
    }()
    
    lazy var seeProfileButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrowshape.turn.up.forward.fill")
        let biggerImage = image?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 25, height: 25))
        button.setImage(biggerImage, for: .normal)

        button.addTarget(self, action: #selector(tappedSeeProfileButton), for: .touchUpInside)
        return button
    }()
    
    lazy var requestedBookLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    lazy var emailLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        let biggerImage = image?.withRenderingMode(.alwaysOriginal).withTintColor(.red).resize(to: CGSize(width: 25, height: 25))
        button.setImage(biggerImage, for: .normal)
        return button
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "checkmark")
        let biggerImage = image?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 25, height: 25))
        button.setImage(biggerImage, for: .normal)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let containerView = UIView()
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(seeProfileButton)
        containerView.addSubview(requestedBookLabel)
        containerView.addSubview(emailLabel)
        
        profileImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height:0 )
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        
        seeProfileButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 30, width: 40, height: 0)
        seeProfileButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        containerView.addSubview(separatorView)
        
        separatorView.anchor(top: profileImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 1)
        
        requestedBookLabel.anchor(top: separatorView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        requestedBookLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        emailLabel.anchor(top: requestedBookLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        addSubview(containerView)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 270)
        
        addSubview(cancelButton)
        addSubview(acceptButton)
        
        cancelButton.anchor(top: containerView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 18, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width:30, height: 0)
        cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -30).isActive = true
        

        acceptButton.anchor(top: cancelButton.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        acceptButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 30).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedSeeProfileButton(){
        self.delegate?.tappedSeeProfileButton(username: usernameLabel.text ?? "")
    }
}

//struct ViewControllerPrevieww: PreviewProvider{
//    static var previews: some View {
//        VCPreview{ SwapCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()) }
//    }
//}



