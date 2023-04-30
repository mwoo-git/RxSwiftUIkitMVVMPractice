//
//  AuthService.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase

struct AuthService {
    static func signinUser(withCredential credential: OAuthCredential) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return result.user
        } catch {
            print("DEBUG: Failed to signinUser\(error.localizedDescription)")
            throw error
        }
    }
}

