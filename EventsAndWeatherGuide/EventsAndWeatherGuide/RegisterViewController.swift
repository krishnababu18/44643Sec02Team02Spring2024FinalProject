//
//  RegisterViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 25/02/2024.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var ConfirmpassTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.isHidden = false
            setupUI()
        }
        
        func setupUI() {
            registerBtn.isEnabled = false // Initially disable the register button
            // Add targets to text fields for text change events
            emailTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            ConfirmpassTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        @objc func textFieldDidChange() {
            // Check if email is valid
            let isEmailValid = isValidEmail(emailTF.text ?? "")
            
            // Check if password and confirm password match
            let doPasswordsMatch = passwordTF.text == ConfirmpassTF.text
            
            // Enable register button only if email is valid and passwords match
            registerBtn.isEnabled = isEmailValid && doPasswordsMatch
        }
        
        func isValidEmail(_ email: String) -> Bool {
            // Simple email validation using regular expression
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        @IBAction func cancel(_ sender: Any) {
            self.dismiss(animated: true)
        }
    }
