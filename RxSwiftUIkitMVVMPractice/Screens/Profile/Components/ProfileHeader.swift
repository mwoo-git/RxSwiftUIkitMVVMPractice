//
//  ProfileHeader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/22.
//

import UIKit
import SDWebImage

class ProfileHeader: UITableViewHeaderFooterView {
    // MARK: - Properties
    
    var vm: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.setDimensions(height: 100, width: 100)
        profileImageView.anchor(top: topAnchor)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(nameLabel)
        nameLabel.centerX(inView: self)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        let stack = UIStackView(arrangedSubviews: [emailLabel, usernameLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: nameLabel.bottomAnchor, paddingTop: 10)
    }
    
    func configure() {
        guard let vm = vm else { return }
        profileImageView.sd_setImage(with: vm.profileImageUrl)
        nameLabel.text = vm.name
        usernameLabel.text = vm.username
        emailLabel.text = vm.email
    }
    
    // MARK: - Actions
}
