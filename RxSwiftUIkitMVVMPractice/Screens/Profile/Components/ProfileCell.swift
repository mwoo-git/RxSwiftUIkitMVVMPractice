//
//  ProfileCell.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/22.
//

import UIKit

class ProfileCell: UITableViewCell {
    // MARK: - Properties
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        addSubview(cellLabel)
        cellLabel.centerY(inView: self)
        cellLabel.anchor(left: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(with label: String) {
        cellLabel.text = label
    }
}
