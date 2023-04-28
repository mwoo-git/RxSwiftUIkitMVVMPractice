//
//  SigninController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/27.
//

import UIKit
import AuthenticationServices

protocol AuthenticationDelegate: class {
    func authenticationComlete()
}

class SigninController: UIViewController {
    // MARK: - Properties
    
    private var vm = SigninViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let brandingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SignInBackground")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(appleSignInButtonTapped(_:)), for: .touchUpInside)
        button.setHeight(50)
        return button
    }()
    
    private lazy var kakaoSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_large_wide"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(kakaoSignInButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비회원으로 둘러보기", for: .normal)
        button.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "로그인"
        
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(brandingImageView)
        brandingImageView.centerX(inView: view)
        brandingImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 70)
        brandingImageView.setDimensions(height: 270, width: 270)
        
        let stack = UIStackView(arrangedSubviews: [kakaoSignInButton, appleSignInButton, guestButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: brandingImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 16, paddingRight: 16)
        
    }
    
    // MARK: - Actions
    
    @objc func appleSignInButtonTapped(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authrizationController = ASAuthorizationController(authorizationRequests: [request])
        authrizationController.delegate = self
        authrizationController.presentationContextProvider = self
        authrizationController.performRequests()
    }
    
    @objc func kakaoSignInButtonTapped(_ sender: Any) {
    }
    
    @objc func guestButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension SigninController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            vm.appleSignInEventOccurred(withTokenId: idTokenString)
        }
    }
}
