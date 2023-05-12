//
//  SecondUsernameController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/11.
//


import UIKit
import Firebase
import FirebaseAuth

class SecondUsernameController: UIViewController {
    // MARK: - Properties
    
    private var name: String
    
    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름 만들기"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let desriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름을 추가하거나 추천 이름을 사용하세요. 언제든지 변경할 수 있습니다."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.setHeight(50)
        textField.clearButtonMode = .always
        textField.placeholder = "사용자 이름"
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }()
    
    private let isPossibleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용할 수 있는 사용자 이름입니다!"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.splitViewController?.view.center ?? CGPoint()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.setDimensions(height: 30, width: 30)
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionUsername()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(desriptionLabel)
        desriptionLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(usernameTextField)
        usernameTextField.anchor(top: desriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(isPossibleLabel)
        isPossibleLabel.anchor(top: usernameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: usernameTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: isPossibleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
    }
    
    // MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        guard let username = sender.text else { return }
        validateUsername(username: username)
    }
    
    @objc func handleNext() {
        guard let username = usernameTextField.text else { return }
        
        let controller = ThirdAgreementController(name: name, username: username)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SuggestionUsername

extension SecondUsernameController {
    private func suggestionUsername() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())
        
        if let atIndex = email.firstIndex(of: "@") {
            let username = String(email[..<atIndex])
            let suggestionUsername = username + currentYear
            usernameTextField.text = suggestionUsername
            validateUsername(username: suggestionUsername)
        }
    }
}

// MARK: - ValidateUsername

extension SecondUsernameController {
    private func validateUsernameFailed() {
        nextButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        nextButton.isEnabled = false
        isPossibleLabel.textColor = .systemRed
        isPossibleLabel.isHidden = false
        activityIndicator.isHidden = true
    }
    
    private func usernameIsEmpty() {
        isPossibleLabel.text = ""
        validateUsernameFailed()
    }
    
    private func validateCharacterFailed() {
        isPossibleLabel.text = "영어 소문자, 숫자, 밑줄, 마침표만 포함될 수 있습니다."
        validateUsernameFailed()
    }
    
    private func validateUsernameLengthFalied() {
        isPossibleLabel.text = "사용자 이름은 30자를 초과할 수 없습니다."
        validateUsernameFailed()
    }
    
    private func usernameIsNotSafe() {
        isPossibleLabel.text = "욕설, 선정적인 문구는 포함할 수 없습니다."
        validateUsernameFailed()
    }
    
    private func usernameAlreadyExists(username: String) {
        isPossibleLabel.text = "이미 사용된 사용자 이름입니다."
        validateUsernameFailed()
    }
    
    private func validateUsername(username: String) {
        nextButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        nextButton.isEnabled = false
        isPossibleLabel.isHidden = true
        activityIndicator.isHidden = false
        
        Task {
            do {
                guard try await FirebaseService.isPossibleUsername(newName: username) else { return usernameAlreadyExists(username: username) }
                
                guard !username.isEmpty else { return usernameIsEmpty() }
                
                guard ValidateService.validateCharacters(withUsername: username) else { return validateCharacterFailed() }
                
                guard ValidateService.isUsernameSafe(withUsername: username) else { return usernameIsNotSafe() }
                
                guard username.count <= 30 else { return validateUsernameLengthFalied() }
                
                isPossibleLabel.text = "사용할 수 있는 사용자 이름입니다."
                isPossibleLabel.textColor = .systemBlue
                isPossibleLabel.isHidden = false
                activityIndicator.isHidden = true
                nextButton.backgroundColor = .systemBlue
                nextButton.isEnabled = true
            } catch {
                print("DEBUG: FirebaseService.isPossibleUsername() failed.")
            }
        }
    }
}
