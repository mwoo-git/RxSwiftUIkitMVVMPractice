//
//  EditDescriptionController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/07.
//

import UIKit

class EditDescriptionController: UIViewController {
    // MARK: - Properties
    
    private let userInfo = UserInfo.shared
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = userInfo.description
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.keyboardType = .twitter
        return textView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(150 - userInfo.description.count)"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Heplers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "소개"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEndEditing))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        view.addSubview(textView)
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        view.addSubview(divider)
        divider.anchor(top: textView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 3, height: 0.5)
        
        view.addSubview(countLabel)
        countLabel.anchor(top: divider.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 12)
        
    }
    
    // MARK: - Actions
    
    @objc func handleEndEditing() {
        guard let text = textView.text else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        userInfo.description = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITextViewDelegate

extension EditDescriptionController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        countLabel.text = "\(150 - text.count)"
        
        if text == userInfo.description {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
    }
}
