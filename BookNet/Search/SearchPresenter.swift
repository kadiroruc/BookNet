//
//  SearchPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.08.2024.
//

import Foundation

final class SearchPresenter {
    
    // MARK: - Private properties -

    private unowned let view: SearchViewInterface
    private let interactor: SearchInteractorInputInterface
    private let wireframe: SearchWireframeInterface
    
    private var books = [BookModel]()
    private var filteredBooks = [BookModel]()
    

    // MARK: - Lifecycle -

    init(view: SearchViewInterface, interactor: SearchInteractorInputInterface, wireframe: SearchWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SearchPresenter: SearchPresenterInterface {
    
    var filteredBooksCount: Int {
        return filteredBooks.count
    }
    
    func viewDidLoad() {
        
        interactor.fetchBooks()
    }

    func viewWillAppear() {
        // Implement any additional logic if needed
    }

    func searchBarTextDidChange(_ searchText: String) {
        filteredBooks = []
        filteredBooks = books.filter { $0.bookName.lowercased().contains(searchText.lowercased()) }
        view.reloadData()
    }

    func didSelectItem(at index: Int) {
        if let userId = filteredBooks[index].userId{
            wireframe.navigateToProfile(with: userId)
        }
        
    }
    
    func filteredBook(at index: Int) -> BookModel {
        return filteredBooks[index]
    }
}

extension SearchPresenter: SearchInteractorOutputInterface {
    func didFetchBooks(_ books: [BookModel]) {
        self.books = books
        //self.filteredBooks = books
        view.reloadData()
    }
}
