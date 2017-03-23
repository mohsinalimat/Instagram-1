//
//  LoginViewModel.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/23/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

struct LoginViewModel {
    
    private let authService: AuthServiceProtocol
    var errorMessage = Variable<String?>(nil)
    var successfullyLoggedIn = Variable<Bool>(false)
    var email = Variable<String?>(nil)
    var password = Variable<String?>(nil)
    var isLoading = Variable<Bool>(false)
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func performLogin() {
        guard let email = email.value,
            let password = password.value else {
                errorMessage.value = "Some unexpected error ocurred, please try again."
                return
        }
        
        guard Validator.isEmailValid(email: email) else {
            errorMessage.value = "Make sure that the email informed is a valid email."
            return
        }
        
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage.value = "Make sure all the fields were typed."
            return
        }
        
        isLoading.value = true
        
        authService.login(email: email, password: password) { (error) in
            self.isLoading.value = false
            guard error == nil else {
                self.errorMessage.value = error?.localizedDescription
                return
            }
            
            self.successfullyLoggedIn.value = true
        }
    }
    
}
