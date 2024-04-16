//
//  SplashViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 24/02/2024.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        perform(#selector(moveToLogin), with: nil, afterDelay: 3)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func moveToLogin() -> Void {
        
        if Auth.auth().currentUser != nil {
            
            let type = UserDefaults.standard.value(forKey: "type") as? String ?? "user"
            if type == "admin" {
                
                self.performSegue(withIdentifier: "splashToAdmin", sender: self)
            }else {
                
                self.performSegue(withIdentifier: "splashToTabBar", sender: self)
            }
            
        }else {
            
            self.performSegue(withIdentifier: "splashToLogin", sender: self)
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

}
