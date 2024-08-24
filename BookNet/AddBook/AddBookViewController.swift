//
//  AddBookViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit
import PKHUD

final class AddBookViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: AddBookPresenterInterface!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    let bookNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 10
        tf.placeholder = "Book Name"
        tf.textAlignment = .center
        return tf
    }()
    let authorNameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 10
        tf.placeholder = "Author Name"
        tf.textAlignment = .center
        return tf
    }()
    let shareButton : UIButton = {
       
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Add Book", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        
        view.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        title = "Add Book For Swap"
        
        setupImageAndTextViews()
        
        presenter.viewDidLoad()
    }
    
    fileprivate func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray5
        containerView.layer.cornerRadius = 20
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 400)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 220)

        
        containerView.addSubview(bookNameTextField)
        bookNameTextField.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, bottom: nil, right: imageView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 45)
        
        containerView.addSubview(authorNameTextField)
        authorNameTextField.anchor(top: bookNameTextField.bottomAnchor, left: bookNameTextField.leftAnchor, bottom: containerView.bottomAnchor, right: bookNameTextField.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(shareButton)
        shareButton.anchor(top: containerView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleAdd(){

        if let bookName = bookNameTextField.text, bookName.count > 0{
            if let authorName = authorNameTextField.text, authorName.count > 0{
                presenter.handleAdd(bookName: bookName, authorName: authorName)
            }else{
                self.show(title: "Error", message: "Enter an author name")
            }
        }else{
            self.show(title: "Error", message: "Enter a book name")
        }
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }

}

// MARK: - Extensions -

extension AddBookViewController: AddBookViewInterface {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showLoading() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    func show(title: String?, message: String) {
        showAlert(title: title, message: message)
    }
    
    func disableShareButton() {
        self.shareButton.backgroundColor = .systemGray5
        self.shareButton.isEnabled = false
    }
    
    func enableShareButton() {
        self.shareButton.backgroundColor = .white
        self.shareButton.isEnabled = true
    }
    
    func showImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    
}
