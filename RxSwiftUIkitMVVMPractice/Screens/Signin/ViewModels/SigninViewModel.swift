//
//  SigninViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/28.
//

import Firebase
import CryptoKit
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

class SigninViewModel {
    // MARK: - Properties
    
    typealias FirebaseUser = FirebaseAuth.User
    typealias KakaoUser = KakaoSDKUser.User
    
    private var user: FirebaseUser?
    
    let output = PublishSubject<Output>()
    
    enum SignInType {
        case kakao
        case apple
    }
    
    enum Output {
        case didFirstSignInWithApple
        case didAlreadySignInWithApple
        case didFailToSignInWithApple(error: Error)
        
        case didFirstSignInWithKakao
        case didAlreadySignInWithKakao
        case didFailToSignInWithKakao(error: Error)
    }
    
    // MARK: - Kakao
    
    /// 카카오 로그인 이벤트 시작(웹과 앱 로그인으로 구분)
    private func kakaoSignIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            //            signInWithKakaoTalkApp()
        } else {
            //            signInWithKakaoWeb()
        }
    }
    
    // MARK: Apple
    
    func appleSignin(withTokenId tokenId: String) async {
        do {
            let nonce = await sha256(await randomNonceString())
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenId, rawNonce: nonce)
            let user = try await AuthService.signinUser(withCredential: credential)
            self.user = user
            await didUserAlreadyRegisterInFirestore(type: .apple)
        } catch {
            output.onNext(.didFailToSignInWithApple(error: error))
        }
    }
    
    private func sha256(_ input: String) async -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) async -> String {
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
    
    private func didUserAlreadyRegisterInFirestore(type: SignInType) async {
        do {
            guard let user = user else { return }
            let status = try await FirebaseService.isUserAlreadyExisted(user: user)
            switch type {
            case .apple:
                output.onNext(status ? .didAlreadySignInWithApple : .didFirstSignInWithApple)
            case .kakao:
                output.onNext(status ? .didAlreadySignInWithKakao : .didFirstSignInWithKakao)
            }
        } catch {
            output.onNext(.didFailToSignInWithApple(error: error))
        }
    }
}

