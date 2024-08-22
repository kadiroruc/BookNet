//
//  PhotoSelectorWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class PhotoSelectorWireframe: BaseWireframe<PhotoSelectorViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = PhotoSelectorViewController()
        super.init(viewController: moduleViewController)

        let interactor = PhotoSelectorInteractor()
        let presenter = PhotoSelectorPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension PhotoSelectorWireframe: PhotoSelectorWireframeInterface {
    
    func navigateToAddScreen(with image: UIImage) {
        let addBookWireFrame = AddBookWireframe(image: image)
        viewController.tabBarController?.tabBar.isHidden = true
        navigationController?.pushWireframe(addBookWireFrame)
    }
    
    func navigateToShareScreen(with image: UIImage) {
        let shareBookWireFrame = ShareBookWireframe(image: image)
        viewController.tabBarController?.tabBar.isHidden = true
        navigationController?.pushWireframe(shareBookWireFrame)
        
    }
    
}
