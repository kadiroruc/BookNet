//
//  MainTabBarController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit
import FirebaseAuth

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let loginVC = LoginRouter.createLoginModule()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController,animated: true)
                
            }
        }
        
//        let homeViewController = HomeRouter.createModule()
        let profileView = ProfileRouter.createProfileModule(with: nil)
//        let searchViewController = SearchRouter.createModule()

        
        let profileNavController = templateNavController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!,rootViewController: profileView)
        
        viewControllers = [profileNavController]
    }
    
    fileprivate func templateNavController(unselectedImage:UIImage, selectedImage:UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let vc = rootViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}

