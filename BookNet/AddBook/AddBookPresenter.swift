//
//  AddBookPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class AddBookPresenter {
    
    // MARK: - Private properties -

    private unowned let view: AddBookViewInterface
    private let interactor: AddBookInteractorInterface
    private let wireframe: AddBookWireframeInterface
    
    private var image: UIImage
    // MARK: - Lifecycle -

    init(view: AddBookViewInterface, interactor: AddBookInteractorInterface, wireframe: AddBookWireframeInterface,image: UIImage) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.image = image
    }
}

// MARK: - Extensions -

extension AddBookPresenter: AddBookPresenterInterface {
    
    func handleAdd(bookName: String, authorName: String) {
        view.disableShareButton()
        view.showLoading()
        interactor.uploadBook(bookName: bookName, authorName: authorName, image: image)
    }
    
    func viewDidLoad() {
        view.showImage(image)
    }
    
}

extension AddBookPresenter: AddBookInteractorOutputInterface{
    func didUploadBook() {
        view.hideLoading()
        view.pop()
        view.show(title: nil, message: "The book has been successfully added.")
        
    }
    
    func didFailToUploadBook(_ error: String) {
        view.show(title: "Error", message: error)
        view.enableShareButton()
    }
    
    
}
