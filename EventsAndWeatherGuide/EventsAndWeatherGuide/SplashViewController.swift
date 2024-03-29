//
//  SplashViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 24/02/2024.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(moveToLogin), with: nil, afterDelay: 3)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func moveToLogin() -> Void {
        
        self.performSegue(withIdentifier: "splashToLogin", sender: self)
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
