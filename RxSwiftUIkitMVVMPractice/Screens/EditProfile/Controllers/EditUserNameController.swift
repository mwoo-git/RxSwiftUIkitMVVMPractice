//
//  EditUserNameController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/07.
//

import UIKit

class EditUserNameController: UIViewController {
    // MARK: - Properties
    
    private let userInfo = UserInfo.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자 이름"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .always
        textField.text = userInfo.userName
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "사람들이 이름, 별명 또는 비즈니스 이름 등 회원님의 알려진 이름을 사용하여 회원님의 계정을 찾을 수 있도록 도와주세요. 사용자 이름은 14일 안에 두 번만 변경할 수 있습니다."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.splitViewController?.view.center ?? CGPoint()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    // MARK: - Heplers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "사용자 이름"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEndEditing))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        view.addSubview(textField)
        textField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        view.addSubview(divider)
        divider.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, height: 0.5)
        
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
    }
    
    private func configureNotificationObservers() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc func handleEndEditing() {
        guard let text = textField.text else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789_.")
            guard text.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(self.handleEndEditing))
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
                self.makeMessageAlert(message: "사용자 이름은 영어 소문자, 숫자, 밑줄, 마침표만 포함될 수 있습니다.")
                return
            }
            
            self.userInfo.userName = text
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        if text == userInfo.userName {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        }
    }
}
