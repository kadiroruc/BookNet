//
//  TabBarViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 5.08.2024.
//

import UIKit

final class TabBarController: UIViewController {

    // MARK: - Public properties -

    var presenter: TabBarPresenterInterface!
    
    private let tabBar = UITabBarController()

    // MARK: - Life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
    }

    private func setupTabBar() {
        addChild(tabBar)
        view.addSubview(tabBar.view)
        
        tabBar.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tabBar.didMove(toParent: self)
        tabBar.tabBar.tintColor = Constants.Colors.appYellow
        
        presenter?.setupViewControllers()
    }

    func setViewControllers(_ viewControllers: [UIViewController]) {
        tabBar.viewControllers = viewControllers
        tabBar.selectedIndex = 0
    }
    
    

}

// MARK: - Extensions -

extension TabBarController: TabBarViewInterface {
}
