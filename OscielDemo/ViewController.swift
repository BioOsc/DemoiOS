//
//  ViewController.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    //MARK: - Comunication Object
    let loginVM: LoginViewModel = LoginViewModel(dataService: RequestToken())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    //MARK: - Sesion Validator
    override func viewDidAppear(_ animated: Bool) {
        if (isSesionActive()) {
            performSegue(withIdentifier: "GoToNext", sender: self)
        }
    }

    func isSesionActive() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.KEY_SESION_ACTIVE)
    }
    //MARK: - User Interaction
    @IBAction func goToNext(_ sender: Any) {
        if (emailTextField.text!.isEmpty) {
            CommonUtils.presentAlert(message: "Email no puede estar vacio", title: "Error", origin: self)
            return
        } else {
            if (!CommonUtils.isValidEmailAddress(emailAddressString: emailTextField.text!)) {
                CommonUtils.presentAlert(message: "Email no valido", title: "Error", origin: self)
                return
            }
        }
        if (passwordTextField.text!.isEmpty) {
            CommonUtils.presentAlert(message: "Password no puede estar vacio", title: "Error", origin: self)
            return
        }
        requestToken(email: emailTextField.text!, password: passwordTextField.text!)
    }
    //MARK: - Comunication
    func requestToken(email: String, password: String) {
        loginVM.requestToken(email: email, password: password)
        loginVM.didFinishFetch = {
            self.performSegue(withIdentifier: "GoToNext", sender: self)
        }
        loginVM.unauthorized = {
            CommonUtils.presentAlert(message: "Credenciales Incorrectas", title: "", origin: self)
        }
        loginVM.showAlertClosure = {
            if (self.loginVM.errorMessage != "" && self.loginVM.errorMessage != nil) {
                CommonUtils.presentAlert(message: self.loginVM.errorMessage!, title: "Error", origin: self)
                self.loginVM.errorMessage = ""
            }
        }
    }

}

