//
//  ChatCell.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/21.
//

import UIKit
import SDWebImage

class ChatCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "bitcoin")
        return iv
    }()
    
    private let nameLabel: UILabel  = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "비트코인"
        return label
    }()
    
    private let descriptionLabel: UILabel  = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "와~ 비트코인 많이 오르네요!"
        label.textColor = .lightGray
        return label
    }()
    
    private let updateTimeLabel: UILabel  = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "어제"
        label.textColor = .lightGray
        return label
    }()
    
    private let newMessagesLabel: UILabel  = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "25"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        let dataStack = UIStackView(arrangedSubviews: [updateTimeLabel, newMessagesLabel])
        dataStack.axis = .vertical
        dataStack.spacing = 4
        dataStack.alignment = .trailing
        
        addSubview(dataStack)
        dataStack.centerY(inView: profileImageView, rightAnchor: rightAnchor, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        
    }
    
    // MARK: - Actions
    
}
