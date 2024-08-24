//
//  TabBarWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 5.08.2024.
//

import UIKit
import FirebaseAuth

final class TabBarWireframe: BaseWireframe<TabBarController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleController = TabBarController()
        super.init(viewController: moduleController)

        let presenter = TabBarPresenter(view: moduleController, wireframe: self)
        moduleController.presenter = presenter
    }

}

// MARK: - Extensions -

extension TabBarWireframe: TabBarWireframeInterface {
    func setupViewControllers() {
        
        let profileWireframe = ProfileWireframe(uid: Auth.auth().currentUser?.uid ?? nil)
        let profileVC = profileWireframe.viewController
        let profileNC = UINavigationController(rootViewController: profileVC)
        
        profileNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        
        let searchWireFrame = SearchWireframe()
        let searchVC = searchWireFrame.viewController
        let searchNC = UINavigationController(rootViewController: searchVC)
        
        searchNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let homeWireFrame = HomeWireframe()
        let homeVC = homeWireFrame.viewController
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        homeNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let photoWF = PhotoSelectorWireframe()
        let photoVC = photoWF.viewController
        let photoNC = UINavigationController(rootViewController: photoVC)
        
        photoNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        
        let swapWF = SwapWireframe()
        let swapVC = swapWF.viewController
        let swapNC = UINavigationController(rootViewController: swapVC)
        
        swapNC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrow.2.squarepath"), selectedImage: UIImage(systemName: "arrow.2.squarepath"))
        
        
        viewController.setViewControllers([homeNC,searchNC,photoNC,swapNC,profileNC])

    }
    
}
