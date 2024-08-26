//
//  TabBarViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 5.08.2024.
//

import UIKit
import GoogleMobileAds

final class TabBarController: UIViewController, UITabBarControllerDelegate, GADFullScreenContentDelegate {

    // MARK: - Public properties -

    var presenter: TabBarPresenterInterface!
    
    private var interstitial: GADInterstitialAd?
    
    private let tabBar = UITabBarController()

    // MARK: - Life cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
        
        Task {
            await loadInterstitial()
        }
    }
    
    func loadInterstitial() async{
        
        do{
            let adUnitId: String = try Configuration.value(for: "INTERSTITIAL_API_KEY")
            
            do {
              interstitial = try await GADInterstitialAd.load(
                withAdUnitID: adUnitId, request: GADRequest())
                
                interstitial?.fullScreenContentDelegate = self
            } catch {

            }
        }catch{
            
        }

    }

    private func setupTabBar() {
        addChild(tabBar)
        view.addSubview(tabBar.view)
        
        tabBar.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tabBar.didMove(toParent: self)
        tabBar.tabBar.tintColor = Constants.Colors.appYellow
        
        tabBar.delegate = self
        
        presenter?.setupViewControllers()
    }

    func setViewControllers(_ viewControllers: [UIViewController]) {
        tabBar.viewControllers = viewControllers
        tabBar.selectedIndex = 0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){

        
        if tabBar.selectedIndex == 1{
            guard let interstitial = interstitial else {return}
            
            // The UIViewController parameter is an optional.
            interstitial.present(fromRootViewController: viewController)
        }
        
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        if tabBar.selectedIndex == 1{
            Task {
                await loadInterstitial()
            }
        }

    }
    

}

// MARK: - Extensions -

extension TabBarController: TabBarViewInterface {
}
