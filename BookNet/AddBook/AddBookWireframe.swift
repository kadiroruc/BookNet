//
//  AddBookWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class AddBookWireframe: BaseWireframe<AddBookViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init(image: UIImage) {
        let moduleViewController = AddBookViewController()
        super.init(viewController: moduleViewController)

        let interactor = AddBookInteractor()
        let presenter = AddBookPresenter(view: moduleViewController, interactor: interactor, wireframe: self, image: image)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
        
    }

}

// MARK: - Extensions -

extension AddBookWireframe: AddBookWireframeInterface {
}
