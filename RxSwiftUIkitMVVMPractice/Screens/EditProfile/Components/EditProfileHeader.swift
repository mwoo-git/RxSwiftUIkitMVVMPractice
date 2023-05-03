//
//  EditProfileHeader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/03.
//

import UIKit

class EditProfileHeader: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private var profileImage: UIImage?
    
    private let eddPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "babydoge"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemGray4
        button.layer.masksToBounds = true
//        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "camera.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray4
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let eddPhotoLabelButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        button.setTitle("사진 수정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
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
        addSubview(eddPhotoButton)
        eddPhotoButton.centerX(inView: self)
        eddPhotoButton.setDimensions(height: 110, width: 110)
        eddPhotoButton.anchor(top: topAnchor, paddingTop: 12)
        eddPhotoButton.layer.cornerRadius = 110 / 2
        
        addSubview(cameraButton)
        cameraButton.setDimensions(height: 30, width: 30)
        cameraButton.anchor(bottom: eddPhotoButton.bottomAnchor, right: eddPhotoButton.rightAnchor)
        
        addSubview(eddPhotoLabelButton)
        eddPhotoLabelButton.centerX(inView: self)
        eddPhotoLabelButton.anchor(top: eddPhotoButton.bottomAnchor, paddingTop: 10)
    }
    
    // MARK: - Actions
    
    @objc func handleProfilePhotoSelect() {
        print("handleProfilePhotoSelect")
    }
    
    
}
