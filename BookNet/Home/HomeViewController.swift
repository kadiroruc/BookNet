//
//  HomeViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 7.08.2024.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var presenter: HomePresenterInterface!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        
        navigationItem.title = "BookNet"
        navigationItem.titleView?.tintColor = UIColor.rgb(red: 251, green: 186, blue: 18)
        
        presenter.viewDidLoad()
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        cell.delegate = self
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
        showAlert(title: "Hata", message: message)
    }
}

extension HomeViewController: CustomPostCellDelegate{
    func likeButtonTapped(in cell: CustomPostCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            presenter.likeButtonTapped(for: indexPath.item)
        }
    }
}
