//
//  ShareBookPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class ShareBookPresenter {
    
    // MARK: - Private properties -

    private unowned let view: ShareBookViewInterface
    private let interactor: ShareBookInteractorInterface
    private let wireframe: ShareBookWireframeInterface
    
    private var image: UIImage

    // MARK: - Lifecycle -

    init(view: ShareBookViewInterface, interactor: ShareBookInteractorInterface, wireframe: ShareBookWireframeInterface, image: UIImage) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.image = image
    }
}

// MARK: - Extensions -

extension ShareBookPresenter: ShareBookPresenterInterface {
    
    func handleShare(bookName: String, authorName: String, postText: String) {
        view.disableShareButton()
        view.showLoading()
        interactor.uploadPost(bookName: bookName, authorName: authorName, postText: postText, image: image)
    }
    
    func viewDidLoad() {
        view.showImage(image)
    }
}

extension ShareBookPresenter: ShareBookInteractorOutputInterface{
    func didUploadPost() {
        view.hideLoading()
        view.pop()
        view.show(title: nil, message: "Kitap başarıyla paylaşıldı.")
        
    }
    
    func didFailToUploadPost(_ error: String) {
        view.show(title: "Hata", message: error)
        view.enableShareButton()
    }
    
    
}
