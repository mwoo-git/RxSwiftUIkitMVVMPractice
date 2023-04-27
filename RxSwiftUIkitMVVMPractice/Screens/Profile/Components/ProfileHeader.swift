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
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Woo"
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "+82 10 9650 3650"
        label.textColor = .lightGray
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "@minwoo_smile"
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
        profileImageView.anchor(top: topAnchor, paddingTop: 16)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(nameLabel)
        nameLabel.centerX(inView: self)
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        let stack = UIStackView(arrangedSubviews: [phoneNumberLabel, userIdLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: nameLabel.bottomAnchor, paddingTop: 10)
    }
    
    func configure() {
        
    }
    
    // MARK: - Actions
}