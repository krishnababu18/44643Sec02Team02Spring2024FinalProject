//
//  AppVC.swift
//  DeccanVhronicle
//
//  Created by Alasakani Prem Rakesh on 2/23/24.
//

import UIKit
import AnimatedGradientView


class AppVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gradientView = AnimatedGradientView(frame: view.bounds)
        gradientView.direction = .up
        gradientView.animationValues = [
            (colors: ["#FFF000"], .up, .axial),
            (colors: ["#808080"], .down, .axial)
        ]
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
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
