//
//  ValidateSevice.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/12.
//

import Foundation

struct ValidateService {
    static let forbiddenWords = ["fuck", "dick", "pussy", "sex", "boob", "porn", "drug", "heroin", "cocaine", "marijuana"]
    
    static func validateString(withUsername text: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789_.")
        let isValid = text.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        return isValid ? true : false
    }
    
    static func isSafeString(withUsername username: String) -> Bool {
        let lowercasedUsername = username.lowercased()
        
        for word in forbiddenWords {
            if lowercasedUsername.contains(word) {
                return false
            }
        }
        
        return true
    }
}
