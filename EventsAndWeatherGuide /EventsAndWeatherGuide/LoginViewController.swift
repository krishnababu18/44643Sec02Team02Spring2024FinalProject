//
//  LoginViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Prem Rakesh on 25/02/2024.
//

import UIKit
import FirebaseAuth
import MBProgressHUD
import AVFoundation
import AudioToolbox

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func login(_ sender: Any) {
        if emailTF.text == "" {
            
            self.showAlert(str: "Please enter email")
        }else if passwordTF.text == "" {
            
            self.showAlert(str: "Please enter password")
        }else {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
                
                MBProgressHUD.hide(for: self!.view, animated: true)
              guard let strongSelf = self else { return }
                print(strongSelf)
              
                if strongSelf.emailTF.text == "admin@admin.com" {
                    UserDefaults.standard.setValue("admin", forKey: "type")
                    UserDefaults.standard.synchronize()
                    strongSelf.performSegue(withIdentifier: "loginToAdmin", sender: strongSelf)
                    AudioServicesPlaySystemSound(1001)
                }else {
                    
                    UserDefaults.standard.setValue("user", forKey: "type")
                    UserDefaults.standard.synchronize()
                    strongSelf.performSegue(withIdentifier: "loginToTabbar", sender: strongSelf)
                    AudioServicesPlaySystemSound(1001)
                }
            }
        }
    }
    
    func showAlert(str: String) -> Void {
        //AudioServicesPlaySystemSound(1322)
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        AudioServicesPlaySystemSound(1151)
    }
    
}
