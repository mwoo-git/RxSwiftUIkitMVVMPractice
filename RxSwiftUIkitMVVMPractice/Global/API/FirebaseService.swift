//
//  UserService.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase
import FirebaseFirestore


struct FirebaseService {
    static func isUserAlreadyExisted(user: User) async throws -> Bool {
        do {
            let document = try await Firestore.firestore().document("users/\(user.uid)").getDocument()
            return document.exists
        } catch {
            print("DEBUG: Failed to isUserAlreadyExisted\(error.localizedDescription)")
            throw error
        }
    }
    
    static func isPossibleUsername(newName: String) async throws -> Bool {
        do {
            let firestore = Firestore.firestore()
            let collectionRef = firestore.collection("users")
            let querySnapshot = try await collectionRef.whereField("username", isEqualTo: newName).getDocuments()
            
            if querySnapshot.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            throw error
        }
    }
}
