//
//  SignUpView.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

class SignUpView: UIViewController, SignUpViewProtocol {
    var presenter: SignUpPresenterProtocol?
    
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
    let signUpLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Kayıt Ol"
        lb.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        lb.font = UIFont.systemFont(ofSize: 44)
        return lb
    }()

    
    let usernameView: UIView = {
    
        let view = UIView()
        let tf = UITextField()
        tf.placeholder = "Ad Soyad"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        let icon = UIImageView(image: UIImage(systemName: "person.circle"))
        icon.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        let lineView = UIView()
        lineView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        view.addSubview(icon)
        view.addSubview(tf)
        view.addSubview(lineView)
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        tf.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 49)
        lineView.anchor(top: tf.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return view
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
        icon.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 27, height: 25)
        tf.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 49)
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
        tf.anchor(top: view.topAnchor, left: icon.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 49)
        lineView.anchor(top: tf.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return view
    }()
    

    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kayıt Ol", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 255, green: 236, blue: 178)
        button.layer.cornerRadius = 22.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    let alreadyHaveAccountButton: UIButton={
        let button = UIButton()
        let firstString = NSAttributedString(string: "Hesabın var mı?",attributes: [.font:UIFont.systemFont(ofSize: 16),.foregroundColor:UIColor.lightGray])
        let secondString = NSAttributedString(string: " Giriş Yap",attributes: [.font:UIFont.boldSystemFont(ofSize: 16),.foregroundColor:UIColor.rgb(red: 251, green: 189, blue: 16)])
        let combinedString = NSMutableAttributedString(attributedString: firstString)
        combinedString.append(secondString)
        button.setAttributedTitle(combinedString, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)

    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
 
    @objc func handleTextInputChange(){
        let emailTextField = emailView.subviews.compactMap { $0 as? UITextField }.first
        let passwordTextField = passwordView.subviews.compactMap { $0 as? UITextField }.first
        let usernameTextField = usernameView.subviews.compactMap { $0 as? UITextField }.first
        
        let isFormValid = emailTextField!
            .text?.count ?? 0 > 0 && passwordTextField!.text?.count ?? 0 > 0 && usernameTextField!.text?.count ?? 0 > 0
        
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 251, green: 189, blue: 16)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 255, green: 236, blue: 178)
        }
    }
    
    @objc func handleAlreadyHaveAccount(){
        presenter?.showLogin()
    }
    
    @objc func signUpButtonTapped(){
        let emailTextField = emailView.subviews.compactMap { $0 as? UITextField }.first
        let passwordTextField = passwordView.subviews.compactMap { $0 as? UITextField }.first
        let usernameTextField = usernameView.subviews.compactMap { $0 as? UITextField }.first
        
        guard let email = emailTextField?.text, email.count > 0 else{return}
        guard let password = passwordTextField?.text, password.count > 0 else{return}
        guard let username = usernameTextField?.text, username.count > 0 else{return}
        
        presenter?.signUpButtonTapped(username: username, password: password, email: email)
    }


    func showLoading() {
        // Show loading indicator
    }

    func hideLoading() {
        // Hide loading indicator
    }

    func showError(_ message: String) {
        // Show error message
    }
    
    func setViews(){
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 251, green: 189, blue: 16)
        
        view.addSubview(circle)
        
        circle.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: -90, paddingLeft: -70, paddingBottom: 0, paddingRight: 0, width: 180, height: 180)
        
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 180, height: 180)
        
        
        logoImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signUpLabel)
        
        signUpLabel.anchor(top: logoImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 50)
        
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [usernameView,emailView,passwordView])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: signUpLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 60, paddingBottom: 0, paddingRight: 60, width: 0, height: 150)
        
        
        view.addSubview(signUpButton)
        
        signUpButton.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 45)
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


    }
}

