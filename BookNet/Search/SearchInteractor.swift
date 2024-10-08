//
//  SearchInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 6.08.2024.
//

import FirebaseDatabase
import FirebaseAuth

final class SearchInteractor {
    weak var presenter: SearchInteractorOutputInterface?
}

// MARK: - Extensions -

extension SearchInteractor: SearchInteractorInputInterface {
    func fetchBooks() {
            let ref = Database.database().reference().child("books")
            ref.observeSingleEvent(of: .value) { [weak self] snapshot in
                var books = [BookModel]()
                guard let dictionaries = snapshot.value as? [String: Any] else { return }

                dictionaries.forEach { key, value in
                    if key == Auth.auth().currentUser?.uid {
                        return
                    }

                    guard let bookDictionary = value as? [String: Any] else { return }

                    bookDictionary.forEach { key, value in
                        let book = BookModel(id: key, userId: nil, dictionary: value as! [String: Any])
                        books.insert(book, at: 0)
                    }
                }

                self?.presenter?.didFetchBooks(books)
            }
        }
}
