//
//  AddBookInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

protocol AddBookWireframeInterface: WireframeInterface {
}

protocol AddBookViewInterface: ViewInterface {
    func showImage(_ image: UIImage)
    func disableShareButton()
    func enableShareButton()
    func show(title: String?, message: String)
    func showLoading()
    func hideLoading()
    func pop()
}

protocol AddBookPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func handleAdd(bookName: String, authorName: String)
}

protocol AddBookInteractorInterface: InteractorInterface {
    func uploadBook(bookName: String, authorName: String, image: UIImage)
}

protocol AddBookInteractorOutputInterface: PresenterInterface{
    func didUploadBook()
    func didFailToUploadBook(_ error: String)
}
