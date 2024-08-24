//
//  SearchInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.08.2024.
//

import UIKit

protocol SearchViewInterface: AnyObject {
    func reloadData()
}

protocol SearchPresenterInterface: AnyObject {
    var filteredBooksCount: Int { get }
    func viewDidLoad()
    func viewWillAppear()
    func searchBarTextDidChange(_ searchText: String)
    func didSelectItem(at index: Int)
    func filteredBook(at index: Int) -> BookModel
}

protocol SearchInteractorInputInterface: AnyObject {
    func fetchBooks()
}

protocol SearchInteractorOutputInterface: AnyObject {
    func didFetchBooks(_ books: [BookModel])
}

protocol SearchWireframeInterface: AnyObject {
    func navigateToProfile(with userId: String)
}
