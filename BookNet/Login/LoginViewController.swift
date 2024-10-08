//
//  LoginViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.08.2024.
//

import UIKit
import PKHUD

final class LoginViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: LoginPresenterInterface!
    
    let circle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 236, blue: 178)
        view.layer.cornerRadius = 90
        return view
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "book"))
        return iv
        
    }()
    let loginLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Login"
        lb.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        lb.font = UIFont.systemFont(ofSize: 44)
        return lb
    }()
    
    
    let emailView: UIView = {
        let view = UIView()
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        let icon = UIImageView(image: UIImage(systemName: "envelope"))
        icon.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        let lineView = UIView()
        lineView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        view.addSubview(icon)
        view.addSubview(tf)
        view.addSubview(lineView)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 27, height: 28)
        tf.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        lineView.anchor(top: tf.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return view
    }()
    let passwordView: UIView = {
        let view = UIView()
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        let icon = UIImageView(image: UIImage(systemName: "lock"))
        icon.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        let lineView = UIView()
        lineView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        view.addSubview(icon)
        view.addSubview(tf)
        view.addSubview(lineView)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 27, height: 28)
        tf.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        lineView.anchor(top: tf.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return view
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 255, green: 236, blue: 178)
        button.layer.cornerRadius = 22.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    let dontHaveAccountButton: UIButton={
        let button = UIButton()
        let firstString = NSAttributedString(string: "Don't have an account yet?",attributes: [.font:UIFont.systemFont(ofSize: 16),.foregroundColor:UIColor.lightGray])
        let secondString = NSAttributedString(string: " Sign Up",attributes: [.font:UIFont.boldSystemFont(ofSize: 16),.foregroundColor:UIColor.rgb(red: 251, green: 189, blue: 16)])
        let combinedString = NSMutableAttributedString(attributedString: firstString)
        combinedString.append(secondString)
        button.setAttributedTitle(combinedString, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    @objc func handleTextInputChange(){
        let emailTextField = emailView.subviews.compactMap { $0 as? UITextField }.first
        let passwordTextField = passwordView.subviews.compactMap { $0 as? UITextField }.first
        
        
        presenter.handleTextInputChange(email: emailTextField?.text, password: passwordTextField?.text)
    }
    
    @objc func handleShowSignUp(){
        presenter.showSignUp()
    }
    
    @objc func loginButtonTapped(){
        let emailTextField = emailView.subviews.compactMap { $0 as? UITextField }.first
        let passwordTextField = passwordView.subviews.compactMap { $0 as? UITextField }.first
        
        guard let email = emailTextField!.text else {return}
        guard let password = passwordTextField!.text else {return}
        
        presenter.loginButtonTapped(email: email, password: password)
    }
    
    func setViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(circle)
        
        circle.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: -90, paddingLeft: -70, paddingBottom: 0, paddingRight: 0, width: 180, height: 180)
        
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
    
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginLabel)
        
        loginLabel.anchor(top: logoImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        setupInputFields()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 50)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailView,passwordView])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: loginLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 60, paddingBottom: 0, paddingRight: 60, width: 0, height: 100)
        
        
        view.addSubview(loginButton)
        
        loginButton.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 45)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }

    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

// MARK: - Extensions -

extension LoginViewController: LoginViewInterface {
    
    func showLoading() {
        HUD.show(.progress,onView: self.view)
    }

    func hideLoading() {
        HUD.hide()
    }

    func showError(_ message: String) {
        showAlert(title: "Failed To Login", message: message)
    }
    
    func updateLoginButton(isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = isEnabled ? UIColor.rgb(red: 251, green: 189, blue: 16) : UIColor.rgb(red: 255, green: 236, blue: 178)
    }
    
    
}
