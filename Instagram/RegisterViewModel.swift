//
//  RegisterViewModel.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/23/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

struct RegisterViewModel {
    
    private let authService: AuthServiceProtocol
    var errorMessage = Variable<String?>(nil)
    var successfullyRegistred = Variable(false)
    private var didPickImage = false
    var name = Variable<String?>(nil)
    var email = Variable<String?>(nil)
    var password = Variable<String?>(nil)
    var confirmPassword = Variable<String?>(nil)
    var isLoading = Variable(false)
    var imageData: Data?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func performRegister() {
        guard let name = name.value,
            let email = email.value,
            let password = password.value,
            let confirmPassword = confirmPassword.value else {
                errorMessage.value = "Some unexpected error ocurred, please try again."
                return
        }
        
        guard didPickImage else {
            errorMessage.value = "Please, you must pick an image, just tap the avatar image in the screen."
            return
        }
        
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            errorMessage.value = "Make sure all the fields were typed."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage.value = "Make sure that your passwords matches."
            return
        }
        
        guard Validator.isEmailValid(email: email) else {
            errorMessage.value = "Make sure that the email informed is a valid email."
            return
        }
        
        guard let imageData = imageData else {
            return
        }
        
        isLoading.value = true
        
        authService.register(name: name, email: email, password: password, profileImageData: imageData) { (error) in
            self.isLoading.value = false
            
            guard error == nil else {
                self.errorMessage.value = error?.localizedDescription
                return
            }
            
            self.successfullyRegistred.value = true
        }
    }
    
    mutating func didPick(image: UIImage) {
        didPickImage = true
        imageData = profileImageDataToUpload(image: image)
    }
    
    private func profileImageDataToUpload(image: UIImage) -> Data? {
        if let data = UIImageJPEGRepresentation(image, 0.3) {
            return data
        }
        return nil
    }
}
