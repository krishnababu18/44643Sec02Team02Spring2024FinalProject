//
//  SignUpPageViewController.swift
//  DeccanVhronicle
//
//  Created by Manideep IOS on 3/8/24.
//

import UIKit

class SignUpPageViewController: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var EmailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmTF: UITextField!
    
    @IBOutlet weak var signUPBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUPact(_ sender: UIButton) {
        
        if nameTF.text == "" {
            showAlert("Please enter your name.")
            return
        }
        
        if EmailTF.text == "" {
            showAlert("Please enter your email.")
            return
        }
        
        if !isValidEmail(EmailTF.text!) {
            showAlert("Please enter a valid email.")
            return
        }
        
        if passwordTF.text == "" {
            showAlert("Please enter your password.")
            return
        }
        
        if confirmTF.text == "" {
            showAlert("Please confirm your password.")
            return
        }
        
        if passwordTF.text != confirmTF.text {
            showAlert("Passwords do not match.")
            return
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
