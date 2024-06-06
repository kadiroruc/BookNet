//
//  SwapViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.06.2024.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class SwapCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var requests = [Request]()
    
    override func viewDidLoad() {
        
        
        
        collectionView.register(CustomRequestsCell.self, forCellWithReuseIdentifier: "cellId")
        
        
    }
    
    //MARK: - CollectionView Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomRequestsCell
    
        cell.usernameLabel.text = "Deneme"
        cell.requestedBookLabel.text = "Requested Book: DenemeDeneme"
        cell.emailLabel.text = "Email: DenemeDenemeDenemedfkai"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 20 // Hücrenin genişliği, collection view'nin genişliği kadar
        let cellHeight: CGFloat = 400 // Hücrenin yüksekliği
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10 // Sağdan ve soldan boşluk miktarı
        
        return UIEdgeInsets(top: 30, left: inset, bottom: 0, right: inset)
    }
}

struct ViewControllerPreview: PreviewProvider{
    static var previews: some View {
        VCPreview{ SwapCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()) }
    }
}



