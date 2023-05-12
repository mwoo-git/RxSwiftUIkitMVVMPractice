//
//  ThirdAgreementController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/12.
//

import UIKit

class ThirdAgreementController: UIViewController {
    // MARK: - Properties
    
    private var name: String
    private var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var agreementChecked = false {
        didSet {
            updateAgreementCheckBoxButton()
            updateNextButtonState()
        }
    }
    
    private var privacyChecked = false {
        didSet {
            updatePrivacyCheckBoxButton()
            updateNextButtonState()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Coingram 약관 및 정책에 동의"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let desriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "계정을 만들려면 모든 약관에 동의해주세요."
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 약관"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let checkAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCheckAll), for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.setHeight(144)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private let agreementCell: UIView = {
        let cell = UIView()
        cell.setHeight(70)
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        return cell
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "이용약관(필수)"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let agreementLink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더 알아보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleAgreementLink), for: .touchUpInside)
        return button
    }()
    
    private let agreementCheckBoxButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "circle")
        button.setDimensions(height: 35, width: 35)
        button.setImage(image?.withTintColor(.lightGray), for: .normal)
        button.addTarget(self, action: #selector(handleAgreementCheckBoxButton), for: .touchUpInside)
        return button
    }()
    
    private let privacyCell: UIView = {
        let cell = UIView()
        cell.setHeight(70)
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        return cell
    }()

    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보처리방침(필수)"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private let privacyLink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더 알아보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePrivacyLink), for: .touchUpInside)
        return button
    }()

    private let privacyCheckBoxButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "circle")
        button.setDimensions(height: 35, width: 35)
        button.setImage(image?.withTintColor(.lightGray), for: .normal)
        button.addTarget(self, action: #selector(handlePrivacyCheckBoxButton), for: .touchUpInside)
        return button
    }()
    
    private let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("동의", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(desriptionLabel)
        desriptionLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(subTitleLabel)
        subTitleLabel.anchor(top: desriptionLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 22, paddingLeft: 12)
        
        view.addSubview(checkAllButton)
        checkAllButton.centerY(inView: subTitleLabel)
        checkAllButton.anchor(top: desriptionLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 22, paddingRight: 12)
        
        view.addSubview(containerView)
        containerView.anchor(top: subTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(agreementCell)
        agreementCell.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 1, paddingLeft: 1, paddingRight: 1)
        
        let stack1 = UIStackView(arrangedSubviews: [agreementLabel, agreementLink])
        stack1.axis = .vertical
        stack1.spacing = 0
        stack1.alignment = .leading
        
        view.addSubview(stack1)
        stack1.centerY(inView: agreementCell)
        stack1.anchor(left: agreementCell.leftAnchor, paddingLeft: 12)
        
        view.addSubview(agreementCheckBoxButton)
        agreementCheckBoxButton.centerY(inView: agreementCell)
        agreementCheckBoxButton.anchor(right: agreementCell.rightAnchor, paddingRight: 12)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        view.addSubview(divider)
        divider.anchor(top: agreementCell.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 1, paddingBottom: 1, height: 0.5)
        
        view.addSubview(privacyCell)
        privacyCell.anchor(top: divider.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingLeft: 1, paddingBottom: 1, paddingRight: 1)

        let stack2 = UIStackView(arrangedSubviews: [privacyLabel, privacyLink])
        stack2.axis = .vertical
        stack2.spacing = 0
        stack2.alignment = .leading

        view.addSubview(stack2)
        stack2.centerY(inView: privacyCell)
        stack2.anchor(left: privacyCell.leftAnchor, paddingLeft: 12)

        view.addSubview(privacyCheckBoxButton)
        privacyCheckBoxButton.centerY(inView: privacyCell)
        privacyCheckBoxButton.anchor(right: privacyCell.rightAnchor, paddingRight: 12)
        
        view.addSubview(agreeButton)
        agreeButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 26, paddingLeft: 12, paddingRight: 12)
        
    }
    
    private func updateAgreementCheckBoxButton() {
        if agreementChecked == true {
            agreementCheckBoxButton.tintColor = .systemBlue
            agreementCheckBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            agreementCheckBoxButton.tintColor = .systemGray
            agreementCheckBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    private func updatePrivacyCheckBoxButton() {
        if privacyChecked == true {
            privacyCheckBoxButton.tintColor = .systemBlue
            privacyCheckBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            privacyCheckBoxButton.tintColor = .systemGray
            privacyCheckBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    private func updateNextButtonState() {
        if privacyChecked && agreementChecked {
            agreeButton.isEnabled = true
            agreeButton.backgroundColor = .systemBlue
        } else {
            agreeButton.isEnabled = false
            agreeButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            agreeButton.backgroundColor = .systemBlue.withAlphaComponent(0.5)
            agreeButton.isEnabled = false
        } else {
            agreeButton.backgroundColor = .systemBlue
            agreeButton.isEnabled = true
        }
    }
    
    @objc func handleAgree() {
        print("동의 버튼")
    }
    
    @objc func handleCheckAll() {
        if agreementChecked == true && privacyChecked == true {
            agreementChecked = false
            privacyChecked = false
        } else {
            agreementChecked = true
            privacyChecked = true
        }
    }
    
    @objc func handleAgreementLink() {
        print("이용약관 링크")
    }
    
    @objc func handleAgreementCheckBoxButton() {
        agreementChecked.toggle()
    }
    
    @objc func handlePrivacyLink() {
        print("개인정보처리방침 링크")
    }
    
    @objc func handlePrivacyCheckBoxButton() {
        privacyChecked.toggle()
    }
}
