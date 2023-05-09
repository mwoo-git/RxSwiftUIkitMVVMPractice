//
//  EditProfileViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/03.
//

import RxRelay
import RxSwift

class EditProfileViewModel {
    let userInfo = UserInfo.shared
    private let disposeBag = DisposeBag()
    
    var tableCellList = [UserProfileElement]()
    
    init() {
        fetchUserInfo()
        bind()
    }
    
    func fetchUserInfo() {
        tableCellList = [
            UserProfileElement(key: "이름", value: userInfo.name),
            UserProfileElement(key: "사용자 이름", value: userInfo.userName),
            UserProfileElement(key: "소개", value: userInfo.description),
            UserProfileElement(key: "링크", value: userInfo.link)
        ]
    }
    
    private func bind() {
        userInfo.didChange
            .subscribe(onNext: { [weak self] _ in
                self?.fetchUserInfo()
            })
            .disposed(by: disposeBag)
    }
}
