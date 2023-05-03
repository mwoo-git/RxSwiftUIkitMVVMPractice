//
//  EditProfileHeader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/03.
//

import UIKit
import PhotosUI
import YPImagePicker

class EditProfileHeader: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    private var profileImage: UIImage?
    
    private let eddPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "babydoge"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemGray4
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
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
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library, .photo]
        config.wordings.libraryTitle = "갤러리"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.wordings.filter = "필터"
        
        let picker = YPImagePicker(configuration: config)
        if let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController?.present(picker, animated: true, completion: nil)
        }
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
            }
            if let photo = items.singlePhoto {
                self.eddPhotoButton.setImage(photo.image, for: .normal)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
