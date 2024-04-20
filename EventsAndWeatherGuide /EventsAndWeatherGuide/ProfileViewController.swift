//
//  ProfileViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 02/04/2024.
//

import UIKit
import FirebaseAuth
import AVFoundation

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = Auth.auth().currentUser?.displayName ?? ""
        emailLbl.text = Auth.auth().currentUser?.email ?? ""
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logout(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.synchronize()
        
        do {
            
            try Auth.auth().signOut()
        } catch {}
        
        
        self.performSegue(withIdentifier: "profileToLogin", sender: self)
        
        AudioServicesPlaySystemSound(1053)
        
        
        
        
        
        
        
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
