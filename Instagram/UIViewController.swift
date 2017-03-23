//
//  UIViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - Animate view up and down
    func animateViewUp(by value: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= value
        }
    }
    
    func animateViewDown(by value: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += value
        }
    }
    
    // MARK: - Keyboard
    func setKeyboardDismissable() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Display Alert Controller
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}
