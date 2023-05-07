//
//  UIViewController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/07.
//

import UIKit

extension UIViewController {
    func makeMessageAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}






