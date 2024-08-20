//
//  TabBarInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 5.08.2024.
//

import UIKit

protocol TabBarWireframeInterface: WireframeInterface {
    func setupViewControllers()
}

protocol TabBarViewInterface: ViewInterface {
    
}

protocol TabBarPresenterInterface: PresenterInterface {
    func setupViewControllers()
}
