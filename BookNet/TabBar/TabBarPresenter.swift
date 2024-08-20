//
//  TabBarPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 5.08.2024.
//

import Foundation

final class TabBarPresenter {
    
    // MARK: - Private properties -

    private unowned let view: TabBarViewInterface
    private let wireframe: TabBarWireframeInterface

    // MARK: - Lifecycle -

    init(view: TabBarViewInterface, wireframe: TabBarWireframeInterface) {
        self.view = view
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension TabBarPresenter: TabBarPresenterInterface {
    func setupViewControllers() {
        wireframe.setupViewControllers()
    }
    
}
