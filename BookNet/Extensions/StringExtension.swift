//
//  StringExtension.swift
//  BookNet
//
//  Created by Abdulkadir Oruç on 27.08.2024.
//

import Foundation

extension String{
    
    func containsInappropriateWords() -> Bool {
        
        guard let filePath = Bundle.main.path(forResource: "badWords", ofType: "txt"),
              let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("Uygunsuz kelimeler yüklenemedi.")
            return false
        }
        
        let inappropriateWords = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        for word in inappropriateWords {
            if self.lowercased().contains(word) {
                return true
            }
        }
        return false
    }
}
