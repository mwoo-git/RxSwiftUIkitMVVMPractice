//
//  rootHeader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/15.
//

import UIKit

class RootHeader: UICollectionReusableView {
    // MARK: - Properties
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        tf.borderStyle = .none
        tf.textColor = .black
        tf.keyboardAppearance = .dark
        tf.backgroundColor = .white
        tf.setHeight(50)
        tf.placeholder = "코인명/심볼 검색"
        return tf
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(searchTextField)
        searchTextField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 20)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        addSubview(bottomDivider)
        bottomDivider.anchor(top: searchTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
}
