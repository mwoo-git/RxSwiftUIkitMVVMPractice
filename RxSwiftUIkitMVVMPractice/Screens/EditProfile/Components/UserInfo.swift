//
//  UserInfo.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/05.
//

import RxSwift

class UserInfo {
    static let shared = UserInfo()
    
    let didChange = PublishSubject<Void>()
    
    var profileImage: UIImage? {
        didSet { didChange.onNext(()) }
    }
    
    var profileImageUrl = "" {
        didSet { didChange.onNext(()) }
    }
    
    var name = "" {
        didSet { didChange.onNext(()) }
    }
    
    var userName = "" {
        didSet { didChange.onNext(())}
    }
    
    var description = "" {
        didSet { didChange.onNext(()) }
    }
    
    var link = "" {
        didSet { didChange.onNext(()) }
    }
    
    private init() { }
    
}
