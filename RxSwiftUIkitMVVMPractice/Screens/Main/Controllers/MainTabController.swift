//
//  MainTabController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/21.
//

import UIKit
import Firebase
import RxSwift

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    
    private var user: CGUser?{
        didSet {
            guard let user = user else { return }
            configureViewController(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
        observeUser()
    }
    
    // MARK: - API
    
    func fetchUser() {
        Task {
            do {
                self.user = try await UserService.fetchUser()
            } catch {
                print("DEBUG: MainTabController.fetchUser() failed. \(error.localizedDescription)")
            }
        }
    }
    
    func observeUser() {
        print("observeUser")
        AuthManager.shared.user
            .subscribe(onNext: { [weak self] user in
                self?.user = user
            })
            .disposed(by: DisposeBag())
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = SigninController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureViewController(withUser user: CGUser) {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let root = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: RootController(collectionViewLayout: layout))
        
        let chat = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: ChatController())
        
        let profile = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: ProfileController(user: user))
        
        viewControllers = [root, chat, profile]
        
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}
