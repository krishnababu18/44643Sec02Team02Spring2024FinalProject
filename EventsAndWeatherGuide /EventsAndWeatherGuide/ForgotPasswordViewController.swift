//
//  ForgotPasswordViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gali Krishna Babu on 26/03/2024.
//

import UIKit
import MBProgressHUD
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func link(_ sender: Any) {
        
        if emailTF.text == "" {
            
            self.showAlert(str: "Please enter email")
            
        }else {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    
                    self.showAlert(str: error.localizedDescription )
                    return
                }
                
                self.showAlert(str: "OTP sent" )
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    func showAlert(str: String) -> Void {
        
        
        // create the alert
        let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            
            self.dismiss(animated: true)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
