//
//  ProfileViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 21.04.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    var selectedButton: UIButton?
    var userId: String?
    var user:User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else{return}
            
            profileImageView.loadImage(urlString: profileImageUrl)
            
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.borderColor = UIColor.black.cgColor
            
            usernameLabel.text = self.user?.username
            
        }
    }
    var posts = [Post]()
    var books = [Book]()
    
    var currentCellType = "Gönderiler"
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
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
        label.textAlignment = .center
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
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tabButtonsClicked), for: .touchUpInside)
        return button
    }()
    let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gönderiler", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(tabButtonsClicked), for: .touchUpInside)
        return button
    }()
    let readingListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Okuma Listem", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 251, green: 186, blue: 18), for: .normal)
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
        
        
        locationLabel.text = "📍Bursa"
        scoreLabel.text = "⚡ 587"

        setViews()
        
        setupCollectionView()
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        fetchUser()

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
        followingLabel.anchor(top: titleLabel.bottomAnchor, left: followersLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 35, paddingBottom: 0, paddingRight: 0, width: 70, height: 20)
        
        view.addSubview(locationLabel)
        locationLabel.anchor(top: usernameLabel.topAnchor, left: followersLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 0)
        
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
        let logOutItem = UIAction(title: "Çıkış Yap") { action in
            self.handleLogOut()
        }
        
        let profileItem = UIAction(title: "Profil Resmini Değiştir") { action in
            self.handleChangeProfile()
        }
        
        let menu = UIMenu(title: "",options: .displayInline,children: [profileItem,logOutItem])
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),menu: menu)
        
        
        
    }

    
    func handleLogOut(){
        let ac = UIAlertController(title: "Çıkış yapmak istiyor musunuz?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Evet", style: .default,handler: {[weak self] action in
            do{
                try Auth.auth().signOut()
                
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self?.present(navController,animated: true)
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
        
        
        
        if sender.titleLabel?.text == "Kütüphane"{
            
            
            
            fetchBooks()
            
            currentCellType = "Kütüphane"
            
            self.collectionView.register(CustomBookCell.self, forCellWithReuseIdentifier: CustomBookCell.identifier)
            self.collectionView.reloadData()
            
        }else if sender.titleLabel?.text == "Gönderiler"{
            
            currentCellType = "Gönderiler"
            
            self.collectionView.register(CustomPostCell.self, forCellWithReuseIdentifier: CustomPostCell.identifier)
            self.collectionView.reloadData()
        }
            
        
        
    }

    func handleChangeProfile(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: libraryButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(CustomPostCell.self, forCellWithReuseIdentifier: CustomPostCell.identifier)
        
        
    }

    
    fileprivate func fetchUser(){
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let userDictionary = snapshot.value as? [String:Any] else{return}
            let user = User(uid: uid, dictionary: userDictionary)
            
            self?.user = user
            
            
        }
        
        
//        Database.fetchUserWithUID(uid: uid) {[weak self] user in
//            self?.user = user
//            
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//                //self?.fetchOrderedPosts()
//            }
//        }
    }
    
    
//    
//    fileprivate func fetchOrderedPosts(){
//        guard let uid = self.user?.uid else {return}
//        
//        let ref = Database.database().reference().child("posts").child(uid)
//        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) {[weak self] snapshot in
//            guard let dictionary = snapshot.value as? [String:Any] else {return}
//            guard let user = self?.user else {return}
//            
//            
//            let post = Post(user: user, dictionary: dictionary)
//            
//            self?.posts.insert(post, at: 0)
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }
//    }
    
    fileprivate func fetchBooks(){
        books = []
        
        guard let uid = self.user?.uid else {return}
        
        
        let ref = Database.database().reference().child("books").child(uid)
        ref.observe(.childAdded) {[weak self] snapshot in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            guard let user = self?.user else {return}
            
            let key = snapshot.key
            let book = Book(id: key, userId: nil, dictionary: dictionary)
            
            self?.books.insert(book, at: 0)
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }

        }
        
        
    }
    

}

//MARK: - Collection View
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CustomBookCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentCellType == "Gönderiler"{
            return posts.count
            
        }else if currentCellType == "Kütüphane"{
            return books.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if currentCellType == "Gönderiler"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPostCell.identifier, for: indexPath) as! CustomPostCell
            return cell
        }else if currentCellType == "Kütüphane"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomBookCell.identifier, for: indexPath) as! CustomBookCell
            cell.delegate = self
            
            if !books.isEmpty{
                cell.bookLabel.text = books[indexPath.item].bookName
                cell.authorLabel.text = books[indexPath.item].authorName
                cell.bookImageView.loadImage(urlString: books[indexPath.item].imageUrl)
                cell.userId = books[indexPath.item].userId
            }
            

            if self.user?.uid != Auth.auth().currentUser?.uid{

                cell.requestButton.isHidden = false
            }

            return cell
        }
        
        return UICollectionViewCell()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: view.frame.width, height: 300)
        
        if currentCellType == "Gönderiler"{
            size = CGSize(width: view.frame.width, height: 300)
        }else if currentCellType == "Kütüphane"{
            size = CGSize(width: view.frame.width, height: 130)
        }
        return size
    }
    
    func showAlert(from cell: CustomBookCell, message: String) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(ac,animated: true)
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
        

        dismiss(animated: true)
        
        if let image = image{
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else{return}
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData) { metadata, error in
                
                if let error = error{
                    print(error)
                    return
                }
                storageRef.downloadURL { url, error in
                    if let imageUrl = url{
                        let profileImageUrl = imageUrl.absoluteString
                    
                        let uid = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
                        
                        let dictionaryValues = ["username":self.user?.username, "profileImageUrl":profileImageUrl]
                        let values = [uid:dictionaryValues]

                        Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { err, ref in
                            if error != nil{
                                print("Failed to save user info into db")
                                return
                            }
                            print("Sucessfully saved user info into db")
                            
                            DispatchQueue.main.async {
                                self.fetchUser()
                            }
                        })
                    }
                }
            }
        }
    }
}

