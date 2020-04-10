//
//  ViewModel.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    // MARK: - Properties
    private var token: Token? {
        didSet { self.didFinishFetch?() }
    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    var errorMessage: String? = "" {
        didSet {
            if errorMessage == "401" {
                self.unauthorized?()
            } else {
                self.showAlertClosure?()
            }
        }
    }
    
    // MARK: Data service variables
    private var dataService: RequestToken?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var unauthorized: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: RequestToken) {
        self.dataService = dataService
    }
    
    // MARK: - Network call
    func requestToken(email: String, password: String) {
        self.dataService?.requestToken(username: email, password: password, completion: { (token, flag, error, errorMessage) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            if errorMessage != "" {
                self.errorMessage = errorMessage
                self.error = nil
                self.isLoading = false
                return
            }
            self.error = nil
            UserDefaults.standard.set(flag, forKey: Constants.KEY_SESION_ACTIVE)
            self.token = token
        })
    }
    
}
