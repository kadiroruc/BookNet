//
//  HomeViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import UIKit
import Firebase
import GoogleMobileAds

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var presenter: HomePresenterInterface!
    var collectionView: UICollectionView!
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        
        navigationItem.title = "BookNet"
        navigationItem.titleView?.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        presenter.viewDidLoad()
        
        setBannerView()
    }
    
    func setBannerView(){
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width

        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)
        
        do{
            bannerView.adUnitID = try Configuration.value(for: "TEST_BANNER_API_KEY")
        }catch{
            print("hata")
        }
        

        bannerView.rootViewController = self

        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomPostCell.self, forCellWithReuseIdentifier: CustomPostCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -143),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func handleRefresh() {
        presenter.handleRefresh()
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfPosts()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPostCell.identifier, for: indexPath) as! CustomPostCell
        cell.likeDelegate = self
        presenter.configureCell(cell, for: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectPost(at: indexPath.item)
    }
}

extension HomeViewController: HomeViewInterface {
    func reloadData() {
        collectionView.reloadData()
    }

    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func showMessage(message: String) {
        showAlert(title: nil, message: message)
    }
}

extension HomeViewController: CustomPostCellLikeDelegate{
    func likeButtonTapped(in cell: CustomPostCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            presenter.likeButtonTapped(for: indexPath.item)
        }
    }
}

extension HomeViewController: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
}
