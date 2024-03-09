//
//  LoginViewController.swift
//  DeccanVhronicle
//
//  Created by Krishna Babu Gali on 3/8/24.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func login(_ sender: Any) {
    if emailTF.text == "" {
    self.showAlert(str: "Please enter email")
    return
            }
    if passwordTF.text == "" {
    self.showAlert(str: "Please enter password")
    return
            }
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyTabBar") as! UITabBarController
    self.navigationController?.pushViewController(vc, animated: true)
        }

    @IBAction func registerBtnClicked(_ sender: Any) {
    let vc = RegisterViewController()
    self.navigationController?.pushViewController(vc, animated: true)
        }
}
