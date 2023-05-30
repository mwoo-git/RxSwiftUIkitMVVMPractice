//
//  ProfileHeaderViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/22.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: CGUser
    
    var name: String {
        return user.name
    }
    
    var username: String {
        return user.username
    }
    
    var email: String {
        return user.email
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: CGUser) {
        self.user = user
    }
}
