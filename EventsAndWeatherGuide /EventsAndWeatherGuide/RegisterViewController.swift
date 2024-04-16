//
//  RegisterViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 25/02/2024.
//

import UIKit
import MBProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func register(_ sender: Any) {
        
        if nameTF.text == "" {
            
            self.showAlert(str: "Please enter name")
        }else if emailTF.text == "" {
            
            self.showAlert(str: "Please enter email")
        }else if passwordTF.text == "" {
            
            self.showAlert(str: "Please enter password")
        }else if confirmPasswordTF.text == "" {
            
            self.showAlert(str: "Please enter confirm password")
        }else {
            
            if passwordTF.text != confirmPasswordTF.text {
                
                self.showAlert(str: "Password not matched.")
            }else {
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
                  
                    if error != nil {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showAlert(str: error?.localizedDescription ?? "Error in saving user")
                    }else{
                        
                        let profile = authResult?.user.createProfileChangeRequest()
                        profile?.displayName = self.nameTF.text!
                        profile?.commitChanges(completion: { error in
                            if error != nil {
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.showAlert(str: error?.localizedDescription ?? "Error in saving user")
                            }else{
                                
                                self.loginUser()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func loginUser() -> Void {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(strongSelf)
          
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            
            UserDefaults.standard.setValue("user", forKey: "type")
            UserDefaults.standard.synchronize()
            
            strongSelf.navigationController?.navigationBar.isHidden = true
            strongSelf.performSegue(withIdentifier: "registerToTabbar", sender: self)
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    
    func showAlert(str: String) -> Void {
        
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
