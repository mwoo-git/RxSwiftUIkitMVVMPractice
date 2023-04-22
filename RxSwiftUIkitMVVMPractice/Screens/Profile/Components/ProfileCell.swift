//
//  ProfileCell.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/22.
//

import UIKit

class ProfileCell: UITableViewCell {
    // MARK: - Properties
    
    private let sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "임시 라벨이여요!"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(sampleLabel)
        sampleLabel.centerY(inView: self)
        sampleLabel.anchor(left: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
}
