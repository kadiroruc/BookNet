//
//  PhotoSelectorInterfaces.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit

protocol PhotoSelectorViewInterface: ViewInterface {
    func reloadData()
}

protocol PhotoSelectorPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func didSelectPhoto(at index: Int)
    var numberOfPhotos: Int { get }
    var selectedImage: UIImage? { get }
    func photo(at index: Int) -> UIImage
    func handleAdd()
    func handleShare()
}

protocol PhotoSelectorInteractorInputInterface: InteractorInterface {
    func fetchPhotos()
}

protocol PhotoSelectorInteractorOutputInterface: PresenterInterface {
    func didFetchPhotos(_ photos: [PhotoModel])
}

protocol PhotoSelectorWireframeInterface: WireframeInterface {
    func navigateToAddScreen(with image: UIImage)
    func navigateToShareScreen(with image: UIImage)
}
