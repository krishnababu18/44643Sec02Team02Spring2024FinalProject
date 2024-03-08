//
//  ViewController.swift
//  DeccanVhronicle
//
//  Created by Manideep IOS on 2/22/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginBTN: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LOGIN(_ sender: Any) {
        if emailTF.text == "" {
            showmsg("Please enter your email.")
            return
        }
        if passwordTF.text == "" {
            showmsg("Please enter your password.")
            return
            
        }
    }
    func showmsg(_ message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

