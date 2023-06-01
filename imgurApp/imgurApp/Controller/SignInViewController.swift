//
//  ViewController.swift
//  imgurApp
//
//  Created by Petar Popovski on 12.5.23.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.isHidden = true
        configUI()
    }
    
    
    fileprivate func configUI() {
        
        // The green imgur color RGB: red: 86, green: 180, blue: 117
        
        emailField.backgroundColor = UIColor(named: "imgurGreen")
        emailField.layer.cornerRadius = 16
        emailField.layer.masksToBounds = true
        
        passwordField.backgroundColor = UIColor(named: "imgurGreen")
        passwordField.layer.cornerRadius = 16
        passwordField.layer.masksToBounds = true
        
        
        signUpButton.layer.cornerRadius = 20
        logInButton.layer.cornerRadius = 20
        
        emailField.layer.borderWidth = 1
        passwordField.layer.borderWidth = 1
        signUpButton.layer.borderWidth = 1
        logInButton.layer.borderWidth = 1
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            startTimer()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            
            if error != nil {
                self.noAccountAlert()
                print(error?.localizedDescription ?? "Error.")
                
            } else {
                
                self.navigateToMainViewController()
                
            }
        })
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        navigateToRegisterController()
        
    }
    
    private func navigateToMainViewController() {
        guard let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainScreenViewController") as? MainScreenViewController else {
            return
        }

        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: true, completion: nil)
    }
    
    private func navigateToRegisterController() {
        guard let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController else {
            return
        }
        
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func noAccountAlert() {
        let noAccountAlert = UIAlertController(title: "No Account With These credentials", message: "Please sign up.", preferredStyle: .alert)
        noAccountAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(noAccountAlert, animated: true, completion: nil)
    }
    
    func startTimer() {
        
        warningLabel.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false ) { [weak self] timer in
            self?.warningLabel.isHidden = true
            timer.invalidate()
        }
    }
    
}

