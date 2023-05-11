//
//  CGUser.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/11.
//

import Foundation

struct CGUser {
    let name: String
    let username: String
    let profileImageUrl: String
    let description: String
    let linkUrl: String
    let linkTitle: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["user_name"] as? String ?? ""
        self.profileImageUrl = dictionary["profile_image_url"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.linkUrl = dictionary["link_url"] as? String ?? ""
        self.linkTitle = dictionary["link_title"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
