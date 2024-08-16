//
//  CustomContextMenuInteraction.swift
//  Project
//
//  Created by Abdulkadir Oruç on 9.08.2024.
//

import UIKit

class CustomContextMenuInteraction: UIContextMenuInteraction {
    var indexPath: IndexPath?

    init(indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(delegate: )
    }
}
