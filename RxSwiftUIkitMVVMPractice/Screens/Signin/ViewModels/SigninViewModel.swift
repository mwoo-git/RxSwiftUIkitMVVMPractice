//
//  SigninViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase
import CryptoKit

class SigninViewModel {
    // MARK: - Properties
    
    typealias FirebaseUser = FirebaseAuth.User
    
    private var tokenId: String?
    private var user: FirebaseUser?
    
    enum SignInType {
        case kakao
        case apple
    }
    
    // MARK: Apple
    
    func appleSignInEventOccurred(withTokenId tokenId: String) {
        self.tokenId = tokenId
        print("토큰 아이디 입니다. \(tokenId)")
        appleSignin()
    }
    
    private func appleSignin() {
        guard let tokenId = tokenId else { return }
        
        let nonce = sha256(randomNonceString())
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenId, rawNonce: nonce)
        
        AuthService.signinUser(withCredential: credential) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.didUserAlreadyRegisterInFirestore(type: .apple)
            case .failure(let error):
                print("DEBUG: Failed to signin user \(error.localizedDescription)")
            }
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
    
    // MARK: - Helpers
    
    private func didUserAlreadyRegisterInFirestore(type: SignInType) {
        guard let user = user else { return }
    }
}
