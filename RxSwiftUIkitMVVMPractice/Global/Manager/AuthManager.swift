//
//  AuthManager.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/20.
//

import Foundation
import RxSwift

final class AuthManager {
    static let shared = AuthManager()
    
    let user = BehaviorSubject<CGUser?>(value: nil)
    
    func updateUser() async throws {
        do {
            let user = try await UserService.fetchUser()
            self.user.onNext(user)
        } catch {
            print("DEBUG: AuthManager.updateUser() failed. \(error.localizedDescription)")
            throw error
        }
    }
    
    private init(){
        Task {
            try await updateUser()
        }
    }
}

