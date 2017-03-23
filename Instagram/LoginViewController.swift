//
//  LoginViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

    fileprivate var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                displayAlert(title: "Error on login", message: errorMessage)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardDismissable()
        
        perform(#selector(checkIfUserIsLoggedIn), with: nil, afterDelay: 0)
    }
    
    @objc
    fileprivate func checkIfUserIsLoggedIn() {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            performSegue(withIdentifier: "userDidLogin", sender: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction fileprivate func loginButtonTapped(_ sender: UIButton) {
        performLogin()
    }
    
    @IBAction fileprivate func unwingToLogin(segue: UIStoryboardSegue) {}
    
    fileprivate func performLogin() {
    
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                errorMessage = "Some unexpected error ocurred, please try again."
                return
        }
    
        guard Validator.isEmailValid(email: email) else {
            errorMessage = "Make sure that the email informed is a valid email."
            return
        }
        
        activityIndicator.startAnimating()
        
        let auth = FIRAuth.auth()
        auth?.signIn(withEmail: email, password: password) { user, error in
            
            defer {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard user != nil else {
                self.errorMessage = "Some unexpected error ocurred, please try again."
                return
            }
            
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            
            self.performSegue(withIdentifier: "userDidLogin", sender: nil)
        }
        
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        animateViewUp(by: 120)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        animateViewDown(by: 120)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.returnKeyType == .next {
            (view.viewWithTag(textField.tag + 1) as? UITextField)?.becomeFirstResponder()
        } else if textField.returnKeyType == .go {
            performLogin()
        }
        return true
    }
}
