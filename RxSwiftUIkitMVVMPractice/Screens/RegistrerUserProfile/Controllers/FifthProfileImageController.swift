//
//  FifthProfileImageController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/16.
//

import UIKit
import YPImagePicker

class FifthProfileImageController: UIViewController {
    // MARK: - Properties
    private var pickerConfig = YPImagePickerConfiguration()
    
    private var profileImage: UIImage {
        didSet { profileImageView.image = profileImage }
    }
    
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.splitViewController?.view.center ?? CGPoint()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.color = .white
        activityIndicator.setDimensions(height: 30, width: 30)
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePicker()
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
        
        complateButton.addSubview(activityIndicator)
        activityIndicator.centerY(inView: complateButton)
        activityIndicator.centerX(inView: complateButton)
    }
    
    // MARK: - Actions
    
    @objc func handleComplateButton() {
        Task {
            do {
                complateButton.setTitle(nil, for: .normal)
                activityIndicator.isHidden = false
                complateButton.isEnabled = false
                try await FirebaseService.uploadProfileImage(withImage: profileImage)
                let user = try await UserService.fetchUser()
                let controller = SixthFinishController(user: user)
                navigationController?.setViewControllers([controller], animated: true)
            } catch {
                makeMessageAlert(message: "오류가 발생했습니다. 잠시 후에 다시 시도해주세요.")
                complateButton.setTitle("완료", for: .normal)
                activityIndicator.isHidden = true
                complateButton.isEnabled = true
                
                print("DEBUG: FifthProfileImageController.handleComplateButton() failed. \(error.localizedDescription)")
            }
        }
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
    
    private func deleteImage() {
        let controller = FourthAddProfileImageController()
        navigationController?.setViewControllers([controller], animated: true)
    }
}

// MARK: - YPImagePicker

extension FifthProfileImageController {
    private func configurePicker() {
        pickerConfig.library.maxNumberOfItems = 1
        pickerConfig.wordings.libraryTitle = "갤러리"
        pickerConfig.wordings.cameraTitle = "카메라"
        pickerConfig.wordings.next = "다음"
        pickerConfig.wordings.cancel = "취소"
        pickerConfig.wordings.filter = "필터"
    }
    
    private func openPhotoLibrary() {
        pickerConfig.library.mediaType = .photo
        pickerConfig.startOnScreen = YPPickerScreen.library
        pickerConfig.screens = [.library]
        
        handleYPImagePicker()
    }
    
    private func openCamera() {
        pickerConfig.library.mediaType = .photo
        pickerConfig.startOnScreen = YPPickerScreen.photo
        pickerConfig.screens = [.photo]
        
        handleYPImagePicker()
    }

    private func handleYPImagePicker() {
        let picker = YPImagePicker(configuration: pickerConfig)
        present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
            }
            if let photo = items.singlePhoto {
                self.profileImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
