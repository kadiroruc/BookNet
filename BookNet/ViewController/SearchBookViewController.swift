//
//  SearchBookViewController.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.05.2024.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchBookController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    let cellId = "cellId"
    
    var books = [Book]()
    var filteredBooks = [Book]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Book Name"
        sb.barTintColor = .gray
        sb.searchTextField.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let lowercaseText = searchBar.text?.lowercased() {
            searchBar.text = lowercaseText
        }
        
        filteredBooks = books.filter({ book in
            return book.bookName.lowercased().contains(searchBar.text!)
        })
        
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView.register(SearchBookCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    func fetchBooks(){
        let ref = Database.database().reference().child("books")
        ref.observeSingleEvent(of:.value) {[weak self] snapshot,arg  in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}

            dictionaries.forEach { key,value in
//                if key == Auth.auth().currentUser?.uid{
//                    return
//                }
                
                guard let bookDictionary = value as? [String:Any] else {return}
                
                bookDictionary.forEach { key,value in
                    let book = Book(id: key, userId: nil, dictionary: value as! [String : Any])
                    self?.books.insert(book, at: 0)
                }
            }
        
        }
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchBookCell
        
        cell.book = filteredBooks[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let userId = filteredBooks[indexPath.item].userId
        
        let profileController = ProfileViewController()
        profileController.userId = userId
        profileController.titleLabel.subviews.first?.isHidden = true
        navigationController?.pushViewController(profileController, animated: true)
    }
}

