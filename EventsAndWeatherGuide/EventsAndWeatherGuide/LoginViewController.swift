//
//  LoginViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 25/02/2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
            super.viewDidLoad()

            signInButton.isEnabled = false
            emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        signInButton.isEnabled = isValidEmail(email) && !password.isEmpty
    }

        @IBAction func login(_ sender: Any) {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }

            if isValidEmail(email) && password == "Password" {
                // Conditions are met, perform segue
                performSegue(withIdentifier: "loginToTabbar", sender: self)
            } else {
                // Display an error message or alert indicating invalid email or password
                print("Invalid email or password. Please try again.")
            }
        }
    }
