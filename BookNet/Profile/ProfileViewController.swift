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
import GoogleMobileAds

final class ProfileViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ProfilePresenterInterface!
    
    var bannerView: GADBannerView!
    
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
        iv.layer.cornerRadius = 65
        return iv
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.text = "Followers"
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.text = "Following"
        label.textAlignment = .center
        return label
    }()
    let followersCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textAlignment = .center
        return label
    }()
    
    let followingCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textAlignment = .center
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
        label.numberOfLines = 2

        return label
    }()
    
    let locationIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "location")
        icon.tintColor = .black
        return icon
    }()
    
//    let scoreLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.rgb(red: 251, green: 186, blue: 18)
//        label.textAlignment = .center
//        
//        return label
//    }()
    
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
        setBannerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        presenter.viewWillAppear()
        
    }
    
    func setBannerView(){
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width

        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)
        
        do{
            let adUnitID: String = try Configuration.value(for: "PROFILE_BANNER_API_KEY")
            bannerView.adUnitID = adUnitID
        }catch{
            
        }

        bannerView.rootViewController = self

        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
    
    
    func setViews(){
        view.backgroundColor = .white
        
        setMenu()
        
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: -40, paddingLeft: -30, paddingBottom: 0, paddingRight: 0, width: 220, height: 60)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 130, height: 130)
        
        
        view.addSubview(followersLabel)
        followersLabel.anchor(top: titleLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(followingLabel)
        followingLabel.anchor(top: titleLabel.bottomAnchor, left: followersLabel.rightAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        
        view.addSubview(followersCount)
        followersCount.anchor(top: followersLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followersCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        

        view.addSubview(followingCount)
        followingCount.anchor(top: followingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        followingCount.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        
        
        view.addSubview(followButton)
        followButton.anchor(top: followersCount.bottomAnchor, left: followersLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        let container = UIView()
        container.addSubview(locationIcon)
        container.addSubview(locationLabel)
        
        container.layer.borderWidth = 1
        container.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        container.layer.cornerRadius = 10
        
        
        locationIcon.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 10, paddingRight: 0, width: 23, height: 0)
        
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: container.rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        locationLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        view.addSubview(container)
        container.anchor(top: nil, left: followersLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        container.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [postsButton,libraryButton,readingListButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 50)
        
    }
    
    func setMenu(){
        let logOutItem = UIAction(title: "Log Out") { _ in
            self.tappedLogOutButton()
        }
        
        let profileItem = UIAction(title: "Change Profile Picture") { _ in
            self.handleChangeProfile()
        }
        
        let locationItem = UIAction(title: "Change Location") { _ in
            self.handleChangeLocation()
        }
        
        let deleteAccountItem = UIAction(title: "Delete Account") { _ in
            self.handleDeleteAccount()
        }
        
        let eulaItem = UIAction(title: "EULA & Terms And Conditions") { _ in
            self.handleEULA()
        }

        
        
        let menu = UIMenu(title: "",options: .displayInline,children: [profileItem,locationItem,deleteAccountItem,eulaItem,logOutItem])
        
        
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
        
        collectionView.anchor(top: libraryButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        
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
    
    func handleChangeLocation(){
        let alertController = UIAlertController(title: nil, message: "Please enter your new location", preferredStyle: .alert)
          
          alertController.addTextField { textField in
              textField.placeholder = "Your Location: Province / District"
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
              if let text = alertController.textFields?.first?.text {
                  self?.presenter.handleChangeLocation(location: text)
              }
          }
          alertController.addAction(submitAction)
          
          present(alertController, animated: true, completion: nil)
    }
    
    func handleDeleteAccount(){
        let ac = UIAlertController(title: "Deleting Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { _ in
            self.presenter.handleDeleteAccount()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac,animated: true)
    }
    
    func handleEULA(){
        if let filePath = Bundle.main.path(forResource: "EULA", ofType: "html"),
           let htmlContent = try? String(contentsOfFile: filePath, encoding: .utf8) {

            let alert = UIAlertController(title: "End User Licence Agreement", message: nil, preferredStyle: .alert)
            
            // WKWebView oluşturulması
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
            webView.loadHTMLString(htmlContent, baseURL: nil)
            
            alert.view.addSubview(webView)
            
            // Auto Layout ayarları
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                        webView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor),
                        webView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor),
                        webView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 45),
                        webView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -45),
                        webView.heightAnchor.constraint(equalToConstant: 350)  // Yüksekliği belirleyin
                    ])

            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            print("Cannot find HTML File")
        }
    }
    

}

// MARK: - Extensions -

extension ProfileViewController: ProfileViewInterface {
    
    func updateFollowButtonTitle(with title: String) {
        followButton.setTitle(title, for: .normal)
    }

    func showFollowButton() {
        followButton.isHidden = false
        titleLabel.isHidden = true
    }
    
    var followButtonTitle: String? {
        return followButton.titleLabel?.text
    }
    
    func updateFollowingLabel(with text: String) {
        followingCount.text = text
    }

    func updateFollowersLabel(with text: String) {
        followersCount.text = text
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
        locationLabel.text = "\(user.location) "
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
    
    func updateLocation(_ newLocation: String) {
        locationLabel.text = newLocation
        showAlert(message: "Location Updated Successfully")
    }
    
    func hideMenu() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func updateBlockButtonTitle(title: String) {
        followButton.setTitle(title, for: .normal)
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

extension ProfileViewController: GADBannerViewDelegate{
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
}
