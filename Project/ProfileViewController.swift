//
//  ProfileViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 21.04.2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var selectedButton: UIButton?
    
    let titleLabel: UIView = {
        let roundedView = UIView()
        roundedView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        roundedView.layer.cornerRadius = 30
        roundedView.clipsToBounds = true
        
        let label = UILabel()
        label.text = "Profilim"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        
        roundedView.addSubview(label)
        
        label.anchor(top: roundedView.topAnchor, left: nil, bottom: roundedView.bottomAnchor, right: roundedView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        return roundedView
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray
        iv.layer.cornerRadius = 70
        return iv
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    let libraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kütüphane", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tabButtonsClicked), for: .touchUpInside)
        return button
    }()
    let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gönderiler", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        //button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tabButtonsClicked), for: .touchUpInside)
        return button
    }()
    let readingListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Okuma Listem", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        //button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tabButtonsClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstString = NSAttributedString(string: "Takipçi",attributes: [.font:UIFont.boldSystemFont(ofSize: 26)])
        let secondString = NSAttributedString(string: "\n     40",attributes: [.font:UIFont.systemFont(ofSize: 24)])
        let combinedString = NSMutableAttributedString(attributedString: firstString)
        combinedString.append(secondString)
        followersLabel.attributedText = combinedString
        
        let firstString1 = NSAttributedString(string: "Takip",attributes: [.font:UIFont.boldSystemFont(ofSize: 26)])
        let secondString1 = NSAttributedString(string: "\n   40",attributes: [.font:UIFont.systemFont(ofSize: 24)])
        let combinedString1 = NSMutableAttributedString(attributedString: firstString1)
        combinedString1.append(secondString1)
        followingLabel.attributedText = combinedString1
        
        usernameLabel.text = "kadir01"
        locationLabel.text = "📍Bursa"
        scoreLabel.text = "⚡ 567 Puan"

        setViews()
    }
    
    func setViews(){
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Çıkış Yap", style: .done, target: self, action: #selector(handleLogOut))
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: -30, paddingBottom: 0, paddingRight: 0, width: 220, height: 60)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        view.addSubview(followersLabel)
        followersLabel.anchor(top: titleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 90, height: 100)
        
        view.addSubview(followingLabel)
        followingLabel.anchor(top: titleLabel.bottomAnchor, left: followersLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 70, height: 20)
        
        view.addSubview(locationLabel)
        locationLabel.anchor(top: usernameLabel.topAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 0)
        
        view.addSubview(scoreLabel)
        scoreLabel.anchor(top: usernameLabel.topAnchor, left: locationLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [libraryButton,postsButton,readingListButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 50)
        
        
    }
    
    @objc func handleLogOut(){
        let ac = UIAlertController(title: nil, message: "Çıkış yapmak istiyor musunuz?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Tamam", style: .default,handler: { action in
            do{
                try Auth.auth().signOut()
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }
            catch{
                
            }
        }))
        ac.addAction(UIAlertAction(title: "İptal", style: .cancel))
        self.present(ac,animated: true)
    }
    
    @objc func tabButtonsClicked(_ sender: UIButton) {
        
        if sender == selectedButton {
            return
        }
    
        selectedButton = sender
        
        
        libraryButton.backgroundColor = .white
        libraryButton.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        postsButton.backgroundColor = .white
        postsButton.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        readingListButton.backgroundColor = .white
        readingListButton.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        
        
        sender.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        sender.setTitleColor(.white, for: .normal)
    }




}
