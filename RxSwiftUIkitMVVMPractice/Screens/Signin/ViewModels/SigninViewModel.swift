//
//  SigninViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase
import CryptoKit
import RxSwift

class SigninViewModel {
    // MARK: - Properties
    
    typealias FirebaseUser = FirebaseAuth.User
    
    private var user: FirebaseUser?
    
    enum SignInType {
        case kakao
        case apple
    }
    
    enum Output {
        case didFirstSignInWithApple
        case didAlreadySignInWithApple
        case didFailToSignInWithApple
    }
    
    // MARK: Apple
    
    func appleSignin(withTokenId tokenId: String) async -> Output {
        do {
            let nonce = sha256(randomNonceString())
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenId, rawNonce: nonce)
            let user = try await AuthService.signinUser(withCredential: credential)
            self.user = user
            let status = try await didUserAlreadyRegisterInFirestore(type: .apple)
            
            return status
        } catch {
            print("DEBUG: Failed to appleSignin\(error.localizedDescription)")
            return .didFailToSignInWithApple
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // MARK: - DidUserAlreadyRegisterInFirestore
    
    private func didUserAlreadyRegisterInFirestore(type: SignInType) async throws -> Output {
        do {
            guard let user = user else { return .didFailToSignInWithApple }
            
            let isExisted = try await FirebaseService.isUserAlreadyExisted(user: user)
            
            return isExisted ? .didAlreadySignInWithApple : .didFirstSignInWithApple
        } catch {
            print("DEBUG: Failed to didUserAlreadyRegisterInFirestore \(error.localizedDescription)")
            throw error
        }
    }
}

