//
//  RegisterViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var confirmPasswordTextField: UITextField!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var viewModel = RegisterViewModel(authService: AuthService())
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImageView()
        setKeyboardDismissable()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.errorMessage.asObservable().subscribe(onNext: { [unowned self] value in
            if let errorMessage = value {
                self.displayAlert(title: "Error on registration", message: errorMessage)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.successfullyRegistred.asObservable().subscribe(onNext: { [unowned self] value in
            if value {
                self.performSegue(withIdentifier: R.segue.registerViewController.userDidRegistred, sender: nil)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.isLoading.asObservable().bindTo(activityIndicator.rx.isAnimating).addDisposableTo(disposeBag)
        nameTextField.rx.text.bindTo(viewModel.name).addDisposableTo(disposeBag)
        emailTextField.rx.text.bindTo(viewModel.email).addDisposableTo(disposeBag)
        passwordTextField.rx.text.bindTo(viewModel.password).addDisposableTo(disposeBag)
        confirmPasswordTextField.rx.text.bindTo(viewModel.confirmPassword).addDisposableTo(disposeBag)
    }
    
    // MARK: - Actions
    @IBAction fileprivate func registetButtonTapped(_ sender: UIButton) {
        viewModel.performRegister()
    }
    
    @objc
    fileprivate func handleImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
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
        } else if textField.returnKeyType == .join {
            viewModel.performRegister()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = originalImage
        }
        if let pickedImage = pickedImage {
            viewModel.didPick(image: pickedImage)
        }
        profileImageView.image = pickedImage
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

// MARK: - Configure UI
extension RegisterViewController {
    fileprivate func setupProfileImageView() {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
    }
}
