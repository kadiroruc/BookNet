//
//  ProfileInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 3.08.2024.
//

import UIKit

protocol ProfileWireframeInterface: WireframeInterface {
    
    func navigateToLoginScreen()
}

protocol ProfileViewInterface: ViewInterface {
    
    var followButtonTitle: String? {get}
    func showUser(with user: UserModel)
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
    func updateProfileImage(_ imageUrl: String)
    func updateTabButtonsAppearance(sender: UIButton)
    func updateTabCellType(with cellType: UICollectionViewCell.Type, reuseIdentifier: String)
    func reloadCollectionView()
    func showAlert(message: String)
    func updateFollowingLabel(with text: NSAttributedString)
    func updateFollowersLabel(with text: NSAttributedString)
    func updateFollowButtonTitle(with title: String)
    func showFollowButton()
    func showContextMenu(for indexPath: IndexPath)
    
}

protocol ProfilePresenterInterface: PresenterInterface {
    
    func viewWillAppear()
    func tappedLogOutButton()
    func didSelectProfileImage(image: UIImage?)
    func tappedTabButtons(_ sender:UIButton)
    
    //Collection view
    var currentCellType: String { get }
    var numberOfItems: Int { get }
    func item(at indexPath: IndexPath) -> Any
    func didSelectItem(at indexPath: IndexPath)
    func sizeForItem(at indexPath: IndexPath) -> CGSize
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath)
    func didLongPressCell(at indexPath: IndexPath)
    
    func setupFollowStats()
    func setupFollowButton()
    func followButtonTapped()
    func tappedDeleteForCell(indexPath: IndexPath)
    func trashButtonTapped(index: Int)
    
}

protocol ProfileInteractorOutputInterface: AnyObject {

    func didFetchUserProfile(_ user: UserModel)
    func didFetchUserPosts(_ posts: [PostModel])
    func didFetchUserBooks(_ books: [BookModel])
    func showMessage(_ message: String)
    func didUserLogOut()
    func updateProfileImage(with imageUrl: String)
    func didFetchFollowingCount(_ count: Int)
    func didFetchFollowerCount(_ count: Int)
    func didCheckIfFollowing(isFollowing: Bool)
    func didFollowUser()
    func didUnfollowUser()
    func didDeletePost(at index: Int)
    func didRequestedBefore()
}

protocol ProfileInteractorInputInterface: AnyObject {
    
    func fetchUserProfile(for uid: String?)
    func userLogOut()
    func uploadProfileImage(user: UserModel, image: UIImage)
    func fetchUserBooks(for uid: String?)
    func fetchUserPosts(for user: UserModel?)
    func fetchFollowingCount(forUserId userId: String)
    func fetchFollowerCount(forUserId userId: String)
    func checkIfFollowing(currentUserId: String, userId: String)
    func followUser(currentUserId: String, userId: String)
    func unfollowUser(currentUserId: String, userId: String)
    func deletePost(forUserId userId: String, postId: String, index: Int)
    func checkDidRequestedBefore(senderId:String,receiverId:String,email: String,requestedBook:String)
}
