//
//  EditProfileCell.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/03.
//

import UIKit

class EditProfileCell: UITableViewCell {
    // MARK: - Properties
    
    private let keyLabel: UILabel = {
        let label = UILabel()
        label.setWidth(100)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        addSubview(keyLabel)
        keyLabel.centerY(inView: self)
        keyLabel.anchor(left: leftAnchor, paddingLeft: 12)
        
        addSubview(valueLabel)
        valueLabel.centerY(inView: self)
        valueLabel.anchor(left: keyLabel.rightAnchor, right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(withData data: UserProfileElement) {
        
        keyLabel.text = data.key
        valueLabel.text = data.value
        
        if data.value == "" {
            valueLabel.text = data.key
            valueLabel.textColor = .lightGray
        }
    }
}
