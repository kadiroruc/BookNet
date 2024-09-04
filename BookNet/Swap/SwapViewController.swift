//
//  SwapViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit
import PKHUD
import MessageUI

final class SwapViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //MARK: -  Properties
    
    var presenter: SwapPresenterInterface!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Book Requests"
        setupCollectionView()
        presenter.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomRequestsCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Extensions -

extension SwapViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomRequestsCell
        
        let request = presenter.request(at: indexPath.item)
        
        presenter.configureCell(cell, for: indexPath, request: request)
        cell.emailDelegate = self
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 20
        let cellHeight: CGFloat = 400
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension SwapViewController: SwapViewInterface {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showMessage(_ message: String) {
        showAlert(title: nil, message: message)
    }
    
    func showLoading() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideLoading() {
        HUD.hide()
    }
}

extension SwapViewController: CustomRequestsCellEmailDelegate{
    func tappedEmailLabel(for email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([email])
            mailComposeVC.setSubject("Subject")
            mailComposeVC.setMessageBody("Your message here", isHTML: false)

            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            print("Mail gönderilemiyor")
            
        }
    }
    
}
