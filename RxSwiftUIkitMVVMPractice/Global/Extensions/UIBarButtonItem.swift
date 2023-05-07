//
//  UIBarButtonItem.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/07.
//

import UIKit

extension UIBarButtonItem {
    static func hideBackButtonTitle() {
        let offset = UIOffset(horizontal: -1000, vertical: 0)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(offset, for: .default)
    }
}
