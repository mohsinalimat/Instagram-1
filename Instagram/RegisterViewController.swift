//
//  RegisterViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var didPickImage = false
    
    fileprivate var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                displayAlert(title: "Error on registration", message: errorMessage)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImageView()
        setKeyboardDismissable()
    }
    
    private func profileImageDataToUpload() -> Data? {
        if let image = profileImageView.image,
            let data = UIImageJPEGRepresentation(image, 0.3) {
            return data
        }
        return nil
    }
    
    // MARK: - Actions
    @IBAction fileprivate func registetButtonTapped(_ sender: UIButton) {
        performRegistration()
    }
    
    fileprivate func performRegistration() {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                errorMessage = "Some unexpected error ocurred, please try again."
                return
        }
        
        guard didPickImage else {
            errorMessage = "Please, you must pick an image, just tap the avatar image in the screen."
            return
        }
        
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            errorMessage = "Make sure all the fields were typed."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Make sure that your passwords matches."
            return
        }
        
        guard Validator.isEmailValid(email: email) else {
            errorMessage = "Make sure that the email informed is a valid email."
            return
        }
        
        activityIndicator.startAnimating()
        
        let auth = FIRAuth.auth()
        
        auth?.createUser(withEmail: email, password: password) { [unowned self] user, error in
            
            defer {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = user else {
                self.errorMessage = "Some unexpected error ocurred, please try again."
                return
            }
            
            guard let data = self.profileImageDataToUpload() else {
                return
            }
            
            let imageName = UUID().uuidString + ".jpg"
            
            let storage = FIRStorage.storage()
            storage.reference()
                .child("users")
                .child(user.uid)
                .child(imageName)
                .put(data, metadata: nil) { metadata, error in
                    guard let url = metadata?.downloadURL() else {
                        return
                    }
                    
                    let values = ["profilePictureURL": url.absoluteString]
                    
                    let database = FIRDatabase.database()
                    database.reference()
                        .child("users")
                        .child(user.uid)
                        .updateChildValues(values)
                }
            
            let values = [
                "name": name,
                "email": email
            ]
            
            let database = FIRDatabase.database()
            database.reference()
                .child("users")
                .child(user.uid)
                .updateChildValues(values)
            
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            self.performSegue(withIdentifier: "userDidRegistred", sender: nil)
        }
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
            performRegistration()
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
        if pickedImage != nil {
            didPickImage = true
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
