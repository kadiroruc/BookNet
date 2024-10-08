//
//  ShareBookWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class ShareBookWireframe: BaseWireframe<ShareBookViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init(image: UIImage) {
        let moduleViewController = ShareBookViewController()
        super.init(viewController: moduleViewController)

        let interactor = ShareBookInteractor()
        let presenter = ShareBookPresenter(view: moduleViewController, interactor: interactor, wireframe: self,image: image)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension ShareBookWireframe: ShareBookWireframeInterface {
}
