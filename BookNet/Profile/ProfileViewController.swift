//
//  ProfileViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//

import UIKit
import PKHUD
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class ProfileViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ProfilePresenterInterface!
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var currentCellType = "Posts"
    
    var indexPath: IndexPath?
    var selectedCell: UICollectionViewCell?
    
    let titleLabel: UIView = {
        let roundedView = UIView()
        roundedView.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        roundedView.layer.cornerRadius = 30
        roundedView.clipsToBounds = true
        
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        
        roundedView.addSubview(label)
        
        label.anchor(top: roundedView.topAnchor, left: nil, bottom: roundedView.bottomAnchor, right: roundedView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 0, height: 0)
        
        return roundedView
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .systemGray
        iv.layer.cornerRadius = 70
        return iv
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 2
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.textAlignment = .center
        label.text = "City and Score Soon"
        label.layer.borderWidth = 1
        label.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.layer.cornerRadius = 10
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
        button.setTitle("Library", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tappedTabButtons), for: .touchUpInside)
        return button
    }()
    let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tappedTabButtons), for: .touchUpInside)
        return button
    }()
    let readingListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reading List", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tappedTabButtons), for: .touchUpInside)
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setupCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        presenter.viewWillAppear()
        
    }
    
    func setViews(){
        view.backgroundColor = .white
        
        setMenu()
        
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: -30, paddingBottom: 0, paddingRight: 0, width: 220, height: 60)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        view.addSubview(followersLabel)
        followersLabel.anchor(top: titleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 90, height: 100)
        
        view.addSubview(followingLabel)
        followingLabel.anchor(top: titleLabel.bottomAnchor, left: followersLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(followButton)
        followButton.anchor(top: followersLabel.bottomAnchor, left: followersLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: -5, paddingLeft: 10, paddingBottom: 0, paddingRight: 35, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        view.addSubview(locationLabel)
        locationLabel.anchor(top: usernameLabel.topAnchor, left: followButton.leftAnchor, bottom: nil, right: followButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 22)
        
        view.addSubview(scoreLabel)
        scoreLabel.anchor(top: usernameLabel.topAnchor, left: followingLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [postsButton,libraryButton,readingListButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 50)
        
    }
    
    func setMenu(){
        let logOutItem = UIAction(title: "Log Out") { action in
            self.tappedLogOutButton()
        }
        
        let profileItem = UIAction(title: "Change Profile Picture") { action in
            self.handleChangeProfile()
        }
        
        let menu = UIMenu(title: "",options: .displayInline,children: [profileItem,logOutItem])
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),menu: menu)
    }
    
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: libraryButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(CustomPostCell.self, forCellWithReuseIdentifier: CustomPostCell.identifier)
        
        
    }
    
    @objc func tappedTabButtons(_ sender: UIButton){
        presenter.tappedTabButtons(sender)
        
    }
    
    @objc func followButtonTapped(_ sender: UIButton){
        presenter.followButtonTapped()
    }
    
    func tappedLogOutButton(){
        presenter.tappedLogOutButton()
    }
    
    func handleChangeProfile(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    

}

// MARK: - Extensions -

extension ProfileViewController: ProfileViewInterface {
    
    func updateFollowButtonTitle(with title: String) {
        followButton.setTitle(title, for: .normal)
    }

    func showFollowButton() {
        followButton.isHidden = false
    }
    
    var followButtonTitle: String? {
        return followButton.titleLabel?.text
    }
    
    func updateFollowingLabel(with text: NSAttributedString) {
        followingLabel.attributedText = text
    }

    func updateFollowersLabel(with text: NSAttributedString) {
        followersLabel.attributedText = text
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func updateTabCellType(with cellType: UICollectionViewCell.Type, reuseIdentifier: String) {
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.reloadData()
    }
    
    
    func updateTabButtonsAppearance(sender: UIButton) {
        
        libraryButton.backgroundColor = .white
        libraryButton.setTitleColor(Constants.Colors.appYellow, for: .normal)
        postsButton.backgroundColor = .white
        postsButton.setTitleColor(Constants.Colors.appYellow, for: .normal)
        readingListButton.backgroundColor = .white
        readingListButton.setTitleColor(Constants.Colors.appYellow, for: .normal)
        
        
        sender.backgroundColor = Constants.Colors.appYellow
        sender.setTitleColor(.white, for: .normal)
    }
    
    func updateProfileImage(_ imageUrl: String) {
        profileImageView.loadImage(urlString: imageUrl)
        profileImageView.clipsToBounds = true
    }
    
    
    func showUser(with user: UserModel) {
        usernameLabel.text = user.username
        profileImageView.loadImage(urlString: user.profileImageUrl)
        profileImageView.clipsToBounds = true
        
        presenter.setupFollowStats()
        presenter.setupFollowButton()
        presenter.tappedTabButtons(postsButton) //List posts at first
    }
    
    
    func showError(_ message: String) {
        HUD.flash(.label(message), delay: 2.0)
    }
    
    func showLoading() {
        
        HUD.show(.progress,onView: self.view)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(ac, animated: true)
    }
    
}

//MARK: - Collection View
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let identifier = presenter.currentCellType == Constants.TabButtons.posts ? CustomPostCell.identifier : CustomBookCell.identifier
        
        if identifier == CustomPostCell.identifier{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomPostCell
            cell.trashDelegate = self
            presenter.configure(cell: cell, at: indexPath)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomBookCell
            cell.trashDelegate = self
            presenter.configure(cell: cell, at: indexPath)
            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return presenter.sizeForItem(at: indexPath)
    }

}


//MARK: - Image Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image: UIImage?

        if let editedImage = info[.editedImage] as? UIImage{
            //profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            image = editedImage

        }else if let originalImage = info[.originalImage] as? UIImage{
            //profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            image = originalImage
        }else{
            image = nil
        }
        
        presenter.didSelectProfileImage(image: image)

        picker.dismiss(animated: true)

    }
}


extension ProfileViewController: CustomPostCellTrashDelegate{
    
    func trashButtonTapped(in cell: CustomPostCell) {
        let ac = UIAlertController(title: nil, message: "Do you want to delete the post?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default,handler: {_ in
            if let indexPath = self.collectionView.indexPath(for: cell) {
                self.presenter.trashButtonTapped(index: indexPath.item,cellType: Constants.TabButtons.posts)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac,animated: true)
    }
}

extension ProfileViewController: CustomBookCellTrashDelegate{
    func trashButtonTapped(in cell: CustomBookCell) {
        let ac = UIAlertController(title: nil, message: "Do you want to delete the book?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default,handler: {_ in
            if let indexPath = self.collectionView.indexPath(for: cell) {
                self.presenter.trashButtonTapped(index: indexPath.item,cellType: Constants.TabButtons.library)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac,animated: true)
    }
    
}

