//
//  PhotoSelectorInteractor.swift
//  Project
//
//  Created by Abdulkadir Oruç on 8.08.2024.
//

import UIKit
import Photos

final class PhotoSelectorInteractor {
    weak var presenter: PhotoSelectorInteractorOutputInterface?
}

// MARK: - Extensions -

extension PhotoSelectorInteractor: PhotoSelectorInteractorInputInterface {
    
    func fetchPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                
                var photos = [PhotoModel]()
                let fetchingOptions = PHFetchOptions()
                fetchingOptions.fetchLimit = 30
                fetchingOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchingOptions)

                DispatchQueue.global(qos: .background).async {
                    allPhotos.enumerateObjects { asset, count, stop in
                        let imageManager = PHImageManager.default()
                        let targetSize = CGSize(width: 200, height: 200)
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                            if let image = image {
                                let photo = PhotoModel(image: image, asset: asset)
                                photos.append(photo)
                                if count == allPhotos.count - 1 {
                                    DispatchQueue.main.async {
                                        self.presenter?.didFetchPhotos(photos)
                                    }
                                }
                            }
                        }
                    }
                }
                
            case .denied, .restricted:
                // Kullanıcı izin vermedi veya erişim kısıtlı
                print("Erişim izni verilmedi.")
                // Kullanıcıya bilgilendirme veya alternatif bir yol sunabilirsiniz
                
            case .notDetermined:
                // Kullanıcı henüz izin vermedi ya da reddetmedi, bu durumda izni beklemelisiniz
                print("Erişim izni henüz belirlenmedi.")
                
            @unknown default:
                // Bilinmeyen bir durum
                print("Bilinmeyen bir durum oluştu.")
            }
        }
        

        }
}
