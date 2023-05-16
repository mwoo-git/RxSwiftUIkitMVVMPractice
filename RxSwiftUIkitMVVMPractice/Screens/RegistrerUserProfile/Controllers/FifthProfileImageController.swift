//
//  FifthProfileImageController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/16.
//

import UIKit
import YPImagePicker

class fifthProfileImageController: UIViewController {
    // MARK: - Properties
    
    private var profileImage: UIImage
    
    init(profileImage: UIImage) {
        self.profileImage = profileImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진 추가됨"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = profileImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 180 / 2
        imageView.clipsToBounds = true
        imageView.setDimensions(height: 180, width: 180)
        
        return imageView
    }()
    
    private let complateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleComplateButton), for: .touchUpInside)
        return button
    }()
    
    private let editImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사진 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleEditImageButton), for: .touchUpInside)
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
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 30)
        
        let stack = UIStackView(arrangedSubviews: [complateButton, editImageButton])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
    }
    
    // MARK: - Actions
    
    @objc func handleComplateButton() {
        print("handleComplateButton")
    }
    
    @objc func handleEditImageButton() {
        let alertController = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "카메라 롤에서 선택", style: .default) { _ in
            self.openPhotoLibrary()
        }
        alertController.addAction(libraryAction)
        
        let cameraAction = UIAlertAction(title: "사진찍기", style: .default) { _ in
            self.openCamera()
        }
        alertController.addAction(cameraAction)
        
        let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: .default) { _ in
            self.deleteImage()
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library]
        config.wordings.libraryTitle = "갤러리"
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
                self.profileImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func openCamera() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo]
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
                self.profileImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func deleteImage() {
        let controller = FourthAddProfileImageController()
        navigationController?.setViewControllers([controller], animated: true)
    }
}
