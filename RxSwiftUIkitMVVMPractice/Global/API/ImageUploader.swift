//
//  ImageUploader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/11.
//

import FirebaseFirestore
import FirebaseStorage
import Firebase
import UIKit

enum ImageUploaderError: Error {
    case imageDataCouldNotBeCreated
    case downloadURLCouldNotBeRetrieved
}

struct ImageUploader {
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            throw ImageUploaderError.imageDataCouldNotBeCreated
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        return try await withCheckedThrowingContinuation { continuation in
            ref.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    ref.downloadURL { url, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let imageUrl = url?.absoluteString {
                            continuation.resume(returning: imageUrl)
                        } else {
                            continuation.resume(throwing: ImageUploaderError.downloadURLCouldNotBeRetrieved)
                        }
                    }
                }
            }
        }
    }
}





