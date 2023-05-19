//
//  SixthFinishController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/20.
//

import UIKit
import SDWebImage

class SixthFinishController: UIViewController {
    // MARK: - Properties
    var user: CGUser
    
    init(user: CGUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 180 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4.withAlphaComponent(0.3)
        imageView.setDimensions(height: 180, width: 180)
        
        return imageView
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.tintColor = .systemGray4.withAlphaComponent(1)
        imageView.isHidden = false
        return imageView
    }()
    
    private var welcomelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let complateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleComplateButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        configureProfileImage()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "코인그램"
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 36)
        
        
        profileImageView.addSubview(iconImageView)
        iconImageView.setDimensions(height: 130, width: 150)
        iconImageView.centerX(inView: profileImageView)
        iconImageView.centerY(inView: profileImageView)
        
        view.addSubview(welcomelabel)
        welcomelabel.centerX(inView: view)
        welcomelabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.leftAnchor, paddingTop: 26, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(complateButton)
        complateButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12 )
    }
    
    func configureProfileImage() {
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
        iconImageView.isHidden = true
    }
    
    func configureLabel() {
        welcomelabel.text = "\(user.username)님, 코인그램에 오신 것을 환영합니다!"
    }
    
    
    // MARK: - Actions
    @objc func handleComplateButton() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let mainTabController = MainTabController()
            
            // 애니메이션 설정
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            
            // UIWindow의 레이어에 애니메이션 적용
            window.layer.add(transition, forKey: kCATransition)
            
            window.rootViewController = mainTabController
        }
    }
}
