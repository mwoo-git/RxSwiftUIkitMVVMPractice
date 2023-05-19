//
//  FourthProfileImageController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/16.
//

import UIKit
import YPImagePicker

class FourthAddProfileImageController: UIViewController {
    // MARK: - Properties
    var pickerConfig = YPImagePickerConfiguration()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진 추가"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let desriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "친구들이 회원님을 알아볼 수 있도록 프로필 사진을 추가하세요. 프로필 사진은 모든 사람에게 공개됩니다."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 180 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4.withAlphaComponent(0.3)
        imageView.setDimensions(height: 180, width: 180)
        
        let iconImageView = UIImageView(image: UIImage(systemName: "person.fill"))
        iconImageView.tintColor = .systemGray4.withAlphaComponent(1)
        imageView.addSubview(iconImageView)
        iconImageView.setDimensions(height: 130, width: 150)
        iconImageView.centerX(inView: imageView)
        iconImageView.centerY(inView: imageView)
        
        return imageView
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사진 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleAddImageButton), for: .touchUpInside)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.splitViewController?.view.center ?? CGPoint()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.color = .black
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
        
        view.addSubview(desriptionLabel)
        desriptionLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: desriptionLabel.bottomAnchor, paddingTop: 30)
        
        let stack = UIStackView(arrangedSubviews: [addImageButton, skipButton])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        skipButton.addSubview(activityIndicator)
        activityIndicator.centerY(inView: skipButton)
        activityIndicator.centerX(inView: skipButton)
        
    }
    
    // MARK: - Actions
    
    @objc func handleAddImageButton() {
        let alertController = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "카메라 롤에서 선택", style: .default) { _ in
            self.openPhotoLibrary()
        }
        alertController.addAction(libraryAction)
        
        let cameraAction = UIAlertAction(title: "사진찍기", style: .default) { _ in
            self.openCamera()
        }
        alertController.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleSkipButton() {
        Task {
            do {
                skipButton.setTitle(nil, for: .normal)
                activityIndicator.isHidden = false
                skipButton.isEnabled = false
                let user = try await UserService.fetchUser()
                let controller = SixthFinishController(user: user)
                navigationController?.setViewControllers([controller], animated: true)
            } catch {
                makeMessageAlert(message: "오류가 발생했습니다. 잠시 후에 다시 시도해주세요.")
                skipButton.setTitle("건너뛰기", for: .normal)
                activityIndicator.isHidden = true
                skipButton.isEnabled = true
                
                print("DEBUG: FourthAddProfileImageController.handleSkipButton() failed.")
            }
        }
    }
}

// MARK: -

extension FourthAddProfileImageController {
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
                let controller = FifthProfileImageController(profileImage: photo.image)
                self.navigationController?.setViewControllers([controller], animated: false)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
