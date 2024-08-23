//
//  ProfilePresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//

import FirebaseAuth
import UIKit

final class ProfilePresenter {
    
    // MARK: - Private properties -

    private unowned let view: ProfileViewInterface
    private let interactor: ProfileInteractorInputInterface
    private let wireframe: ProfileWireframeInterface

    // MARK: - Lifecycle -

    init(view: ProfileViewInterface, interactor: ProfileInteractorInputInterface, wireframe: ProfileWireframeInterface,uid: String?) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.uid = uid
    }
    
    //var uid: String?
    private let uid: String?
    var user: UserModel?
    var selectedButton: UIButton?
    var currentCellType: String = Constants.TabButtons.posts
    
    var posts: [PostModel] = []
    var books: [BookModel] = []
}

// MARK: - Extensions -

extension ProfilePresenter: ProfilePresenterInterface {
    
    func setupFollowButton() {
         guard let currentUserId = Auth.auth().currentUser?.uid, let userId = uid else { return }
        
         if currentUserId != userId {
             view.showFollowButton()
             interactor.checkIfFollowing(currentUserId: currentUserId, userId: userId)
         }
     }

     func followButtonTapped() {
         view.showLoading()
         guard let currentUserId = Auth.auth().currentUser?.uid, let userId = user?.uid else { return }
         
         if view.followButtonTitle == "Unfollow" {
             interactor.unfollowUser(currentUserId: currentUserId, userId: userId)
         } else {
             interactor.followUser(currentUserId: currentUserId, userId: userId)
         }
     }

    func viewWillAppear() {
        view.showLoading()
        
        if let uid = uid{
            interactor.fetchUserProfile(for: uid)
        }else{
            interactor.fetchUserProfile(for: Auth.auth().currentUser?.uid)
        }
    }
    
    
    func tappedLogOutButton() {
        interactor.userLogOut()
    }
    
    func didSelectProfileImage(image: UIImage?) {
        view.showLoading()
        if let image = image, let user = user{
            interactor.uploadProfileImage(user: user, image: image)
        }

    }
    
    func tappedTabButtons(_ sender: UIButton) {
        if sender == selectedButton {
            return
        }
        
        selectedButton = sender
        
        view.updateTabButtonsAppearance(sender: sender)
        
        if sender.titleLabel?.text == Constants.TabButtons.library {

            interactor.fetchUserBooks(for: self.user?.uid)
            
            currentCellType = Constants.TabButtons.library
            
            view.updateTabCellType(with: CustomBookCell.self, reuseIdentifier: CustomBookCell.identifier)

            
        }else if sender.titleLabel?.text == Constants.TabButtons.posts{
            
            interactor.fetchUserPosts(for: self.user)
            
            currentCellType = Constants.TabButtons.posts
            
            view.updateTabCellType(with: CustomPostCell.self, reuseIdentifier: CustomPostCell.identifier)
        }else if sender.titleLabel?.text == Constants.TabButtons.readingList{
            view.showAlert(message: "Preparing...")
        }
    }
    
    func setupFollowStats() {
        guard let userId = self.user?.uid else { return }
        interactor.fetchFollowingCount(forUserId: userId)
        interactor.fetchFollowerCount(forUserId: userId)
     }
    
    //Collection View
    var numberOfItems: Int {
        return currentCellType == Constants.TabButtons.posts ? posts.count : books.count
    }

    func item(at indexPath: IndexPath) -> Any {
        return currentCellType == Constants.TabButtons.posts ? posts[indexPath.item] : books[indexPath.item]
    }

    func didSelectItem(at indexPath: IndexPath) {
        // Item selection handling
    }

    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return currentCellType == Constants.TabButtons.posts ? CGSize(width: UIScreen.main.bounds.width, height: 300) : CGSize(width: UIScreen.main.bounds.width, height: 130)
    }

    func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        if currentCellType == Constants.TabButtons.posts, let cell = cell as? CustomPostCell {
            let post = posts[indexPath.item]
            cell.usernameLabel.text = post.user.username
            cell.profileImageView.loadImage(urlString: post.user.profileImageUrl)
            cell.bookImageView.loadImage(urlString: post.bookImageUrl)
            cell.bookLabel.text = post.bookName
            cell.postLabel.text = "\"\(post.postText)\""
            cell.dateLabel.text = post.creationDate.timeAgoDisplay()
            cell.postDescriptionLabel.text = post.autherName
            cell.trashButton.isHidden = false
            cell.likeButton.isEnabled = false
            
            if let likes = post.likes{
                cell.likeCountLabel.text = "\(likes.count)"
                
                if let uid = Auth.auth().currentUser?.uid{
                    if likes.contains(uid){
                        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }else{
                        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }

            }
            
        } else if currentCellType == Constants.TabButtons.library, let cell = cell as? CustomBookCell {
            
            let book = books[indexPath.item]
            cell.bookLabel.text = book.bookName
            cell.authorLabel.text = book.authorName
            cell.bookImageView.loadImage(urlString: book.imageUrl)
            cell.userId = book.userId
            cell.delegate = self
            
            if user?.uid != Auth.auth().currentUser?.uid {
                cell.requestButton.isHidden = false
            }else{
                cell.trashButton.isHidden = false
            }
        }
    }
    
    func trashButtonTapped(index: Int, cellType: String) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        if cellType == Constants.TabButtons.posts{
            interactor.deletePost(forUserId: uid, postId: posts[index].postId,index: index)
        }else if cellType == Constants.TabButtons.library{
            interactor.deleteBook(userId: uid, bookId: books[index].id, index: index)
        }

    }
    
    func handleChangeLocation(location: String){
        guard let uid = uid else{return}
        self.interactor.changeLocation(for: uid, newLocation: location)
    }
    
}

extension ProfilePresenter: ProfileInteractorOutputInterface {
    
    func didCheckIfFollowing(isFollowing: Bool) {
        let title = isFollowing ? "Unfollow" : "Follow"
        
        view.updateFollowButtonTitle(with: title)
    }

    func didFollowUser() {
        view.hideLoading()
        if let uid = user?.uid{
            interactor.fetchFollowerCount(forUserId: uid)
        }
        
        view.updateFollowButtonTitle(with: "Unfollow")
    }

    func didUnfollowUser() {
        view.hideLoading()
        if let uid = user?.uid{
            interactor.fetchFollowerCount(forUserId: uid)
        }
        view.updateFollowButtonTitle(with: "Follow")
    }
    
    func didFetchUserBooks(_ books: [BookModel]) {
        self.books = []
        self.books = books
        view.reloadCollectionView()
    }
    

    func didFetchUserProfile(_ user: UserModel) {
        view.hideLoading()
        self.user = user
        view.showUser(with: user)
    }
    
    func didFetchUserPosts(_ posts: [PostModel]) {
        self.posts = []
        self.posts = posts
        view.reloadCollectionView()
    }
    
    func showMessage(_ message: String) {
        view.hideLoading()
        view.showError(message)
    }
    
    func didUserLogOut() {
        wireframe.navigateToLoginScreen()
    }
    
    func updateProfileImage(with imageUrl: String) {
        view.hideLoading()
        view.updateProfileImage(imageUrl)
    }
    
    func didFetchFollowingCount(_ count: Int) {
        view.updateFollowingLabel(with: "\(count)")
    }

    func didFetchFollowerCount(_ count: Int) {
        view.updateFollowersLabel(with: "\(count)")
    }
    
    func didDeletePost(at index: Int) {
        posts.remove(at: index)
        view.reloadCollectionView()
        view.showAlert(message: "The post successfully deleted")
    }
    
    func didRequestedBefore() {
        view.showAlert(message: "You have already requested book from this user.")
    }
    
    func didDeleteBook(at index: Int) {
        books.remove(at: index)
        view.reloadCollectionView()
        view.showAlert(message: "The book successfully deleted")
    }
    
    func didChangeLocation(_ newLocation: String) {
        view.updateLocation(newLocation)
    }
    
}

extension ProfilePresenter: CustomBookCellDelegate {
    func showAlert(from cell: CustomBookCell, message: String) {
        view.showAlert(message: message)
    }
    
    func requestButtonTapped(senderId: String, receiverId: String, email: String, requestedBook:String) {
        
        interactor.checkDidRequestedBefore(senderId: senderId, receiverId: receiverId,email: email,requestedBook: requestedBook)
    }
}
