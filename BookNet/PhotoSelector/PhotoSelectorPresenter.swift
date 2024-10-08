//
//  PhotoSelectorPresenter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

final class PhotoSelectorPresenter {
    
    // MARK: - Private properties -

    private unowned let view: PhotoSelectorViewInterface
    private let interactor: PhotoSelectorInteractorInputInterface
    private let wireframe: PhotoSelectorWireframeInterface
    
    private var photos = [PhotoModel]()
    private var selectedIndex: Int?

    // MARK: - Lifecycle -

    init(view: PhotoSelectorViewInterface, interactor: PhotoSelectorInteractorInputInterface, wireframe: PhotoSelectorWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension PhotoSelectorPresenter: PhotoSelectorPresenterInterface {
    func handleAdd() {
        if let selectedImage = selectedImage{
            wireframe.navigateToAddScreen(with: selectedImage)
        }
    }
    
    func handleShare() {
        if let selectedImage = selectedImage{
            wireframe.navigateToShareScreen(with: selectedImage)
        }
    }
    
    
    func viewDidLoad() {
        interactor.fetchPhotos()
    }
    
    func didSelectPhoto(at index: Int) {
        selectedIndex = index
    }
    
    var numberOfPhotos: Int {
        return photos.count
    }
    
    var selectedImage: UIImage? {
        guard let selectedIndex = selectedIndex else { return nil }
        return photos[selectedIndex].image
    }
    
    func photo(at index: Int) -> UIImage {
        return photos[index].image
    }
}

extension PhotoSelectorPresenter: PhotoSelectorInteractorOutputInterface {
    func didFetchPhotos(_ photos: [PhotoModel]) {
        self.photos = photos
        view.reloadData()
    }
}
