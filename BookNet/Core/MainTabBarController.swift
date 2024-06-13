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
        
        self.delegate = self
        
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
        
        let homeNavController = templateNavController(unselectedImage: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!,rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let searchNavController = templateNavController(unselectedImage: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!,rootViewController: SearchBookController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let swapNavController = templateNavController(unselectedImage: UIImage(systemName: "arrow.2.squarepath")!, selectedImage: UIImage(systemName: "arrow.2.squarepath")!,rootViewController: SwapCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusNavController = templateNavController(unselectedImage: UIImage(systemName: "plus.app")!, selectedImage: UIImage(systemName: "plus.app.fill")!)
        
        
        let profileNavController = templateNavController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!,rootViewController: ProfileViewController())
        

        tabBar.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        tabBar.backgroundColor = .systemGray5
        
        viewControllers = [homeNavController,
                           searchNavController,
                           swapNavController,
                           plusNavController,
                           profileNavController]
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 3{
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            return false
        }else{
            return true
        }

    }

}


