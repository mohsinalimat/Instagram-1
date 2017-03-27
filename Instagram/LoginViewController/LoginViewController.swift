//
//  LoginViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

    fileprivate let viewModel = LoginViewModel(authService: AuthService())
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardDismissable()
        bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        viewModel.errorMessage.asObservable().subscribe(onNext: { [unowned self] message in
            if let message = message {
                self.displayAlert(title: "Error on login", message: message)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.successfullyLoggedIn.asObservable().subscribe(onNext: { [unowned self] value in
            if value {
                self.performSegue(withIdentifier: R.segue.loginViewController.userDidLogin, sender: nil)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.isLoading.asObservable().subscribe(onNext: { [unowned self] value in
            if value {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }).addDisposableTo(disposeBag)
        
        emailTextField.rx.text.bindTo(viewModel.email).addDisposableTo(disposeBag)
        passwordTextField.rx.text.bindTo(viewModel.password).addDisposableTo(disposeBag)
//        activityIndicator.rx.isAnimating.bind(to: viewModel.isLoading).addDisposableTo(disposeBag)
    }
    
    // MARK: - Actions
    @IBAction fileprivate func loginButtonTapped(_ sender: UIButton) {
        viewModel.performLogin()
    }
    
    @IBAction fileprivate func unwingToLogin(segue: UIStoryboardSegue) {}
    
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
            viewModel.performLogin()
        }
        return true
    }
}
