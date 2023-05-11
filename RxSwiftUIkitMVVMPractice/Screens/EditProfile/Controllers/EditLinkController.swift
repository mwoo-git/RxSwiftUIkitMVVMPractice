//
//  EditLinkController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/11.
//

import UIKit

class EditLinkController: UIViewController {
    // MARK: - Properties
    
    private let userInfo = UserInfo.shared
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "URL"
        label.setWidth(120)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.setWidth(120)
        return label
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .always
        textField.text = userInfo.linkUrl
        textField.placeholder = "http://example.com"
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .always
        textField.text = userInfo.linkTitle
        textField.keyboardType = .URL
        return textField
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
        
        urlTextField.becomeFirstResponder()
    }
    
    // MARK: - Heplers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "링크 수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEndEditing))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        view.addSubview(urlLabel)
        urlLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 18, paddingLeft: 12)
        
        view.addSubview(urlTextField)
        urlTextField.centerY(inView: urlLabel)
        urlTextField.anchor(left: urlLabel.rightAnchor, right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: urlLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 12)
        
        view.addSubview(titleTextField)
        titleTextField.centerY(inView: titleLabel)
        titleTextField.anchor(left: titleLabel.rightAnchor, right: view.rightAnchor, paddingRight: 12)
        
        let urlDivider = UIView()
        urlDivider.backgroundColor = .lightGray
        
        let titleDivider = UIView()
        titleDivider.backgroundColor = .lightGray
        
        view.addSubview(urlDivider)
        urlDivider.anchor(top: urlTextField.bottomAnchor, left: urlTextField.leftAnchor, right: urlTextField.rightAnchor, paddingTop: 5, height: 0.5)
        
        view.addSubview(titleDivider)
        titleDivider.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, right: titleTextField.rightAnchor, paddingTop: 5, height: 0.5)
        
    }
    
    private func configureNotificationObservers() {
        urlTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc func handleEndEditing() {
        guard let url = urlTextField.text else { return }
        guard let title = titleTextField.text else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.userInfo.linkUrl = url
            self.userInfo.linkTitle = title
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        guard let url = urlTextField.text else { return }
        guard let title = titleTextField.text else { return }
        if url == userInfo.linkUrl && title == userInfo.linkTitle {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        }
    }
}

