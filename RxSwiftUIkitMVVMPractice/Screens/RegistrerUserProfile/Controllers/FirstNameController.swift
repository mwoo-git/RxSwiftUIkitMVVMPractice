//
//  FirstNameController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/11.
//

import UIKit

class FirstNameController: UIViewController {
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 입력"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let desriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "친구들이 회원님을 찾을 수 있도록 이름을 추가하세요."
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.setHeight(50)
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.placeholder = "성명"
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(desriptionLabel)
        desriptionLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: desriptionLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
    }
    
    // MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            nextButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
            nextButton.isEnabled = false
        } else {
            nextButton.backgroundColor = .systemBlue
            nextButton.isEnabled = true
        }
    }
    
    @objc func handleNext() {
        guard let name = nameTextField.text else { return }
        
        if name.count > 30 {
            makeMessageAlert(message: "이름은 30자를 초과할 수 없습니다.")
            return
        }
        
        let controller = SecondUsernameController(name: name)
        navigationController?.pushViewController(controller, animated: true)
    }
}
