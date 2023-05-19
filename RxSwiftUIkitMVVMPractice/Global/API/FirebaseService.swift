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
    
    static func uploadProfileImage(withImage image: UIImage) async throws {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let imageUrl = try await ImageUploader.uploadImage(image: image)
            let data: [String: Any] = ["profileImageUrl": imageUrl]
            try await Firestore.firestore().collection("users").document(uid).setData(data)
        } catch {
            print("DEBUG: ImageUploader.uploadProfileImage(withUrl) failed. \(error.localizedDescription)")
            throw error
        }
    }
}
