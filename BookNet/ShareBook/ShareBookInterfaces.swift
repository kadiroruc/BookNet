//
//  ShareBookInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

protocol ShareBookWireframeInterface: WireframeInterface {
}

protocol ShareBookViewInterface: ViewInterface {
    func showImage(_ image: UIImage)
    func disableShareButton()
    func enableShareButton()
    func show(title: String?, message: String)
    func showLoading()
    func hideLoading()
    func pop()
}

protocol ShareBookPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func handleShare(bookName: String, authorName: String, postText: String)
}

protocol ShareBookInteractorInterface: InteractorInterface {
    func uploadPost(bookName: String, authorName: String, postText: String, image: UIImage)
}

protocol ShareBookInteractorOutputInterface: PresenterInterface{
    func didUploadPost()
    func didFailToUploadPost(_ error: String)
}
