//
//  RegisterViewController.swift
//  imgurApp
//
//  Created by Petar Popovski on 16.5.23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var enterEmailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var warningLabel: UILabel!
    
    
    var registerButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.isHidden = true
        configUI()
    }
    
    func configUI() {
        
        enterEmailField.backgroundColor = UIColor(named: "imgurGreen")
        enterEmailField.layer.cornerRadius = 16
        enterEmailField.layer.masksToBounds = true
        
        passwordField.backgroundColor = UIColor(named: "imgurGreen")
        passwordField.layer.cornerRadius = 16
        passwordField.layer.masksToBounds = true
        
        usernameField.backgroundColor = UIColor(named: "imgurGreen")
        usernameField.layer.cornerRadius = 16
        usernameField.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = 20
        
        enterEmailField.layer.borderWidth = 1
        passwordField.layer.borderWidth = 1
        registerButton.layer.borderWidth = 1
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        registerButtonTapped = true
        createAccount()
        
    }
    
    func createAccount () {
        
        warningLabel.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] timer in
            self?.warningLabel.isHidden = true
            timer.invalidate()
        }
        
        guard let email = enterEmailField.text, !email.isEmpty else {
            return warningLabel.text = "Please enter e-mail."
        }
        
        guard let username = usernameField.text, !username.isEmpty else {
            return warningLabel.text = "Please enter a unique username."
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            return warningLabel.text = "Please enter password."
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard self != nil else {
                return
            }
            
            if error == nil {
                self?.navigationController?.popViewController(animated: true)
                print("You have created an account successfully.")
                return
            } else {
                print("Account creation failed.")
            }
        })
    }
    
}
