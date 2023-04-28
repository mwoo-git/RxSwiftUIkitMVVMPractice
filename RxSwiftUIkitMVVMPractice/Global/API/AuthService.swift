//
//  AuthService.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase

struct AuthService {
    static func signinUser(withCredential credential: OAuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let authResult = result else { return }
            completion(.success(authResult.user))
        }
    }
}

