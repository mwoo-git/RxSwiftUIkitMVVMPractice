//
//  UIAlertAction.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Mac on 2023/05/17.
//

import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
