//
//  MainTabBarController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 20.04.2024.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do{
//            try Auth.auth().signOut()
//        }
//        catch{
//            
//        }
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController,animated: true)
            }
        }
        

        


        setupViewControllers()
    }
    

    func setupViewControllers(){
        
        //userProfile
        let profileNavController = templateNavController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!,rootViewController: ProfileViewController())
        

        tabBar.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        tabBar.backgroundColor = .systemGray5
        
        viewControllers = [profileNavController]
        
        //modify tabbar items insets
        guard let items = tabBar.items else{return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage:UIImage, selectedImage:UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let vc = rootViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }

}
