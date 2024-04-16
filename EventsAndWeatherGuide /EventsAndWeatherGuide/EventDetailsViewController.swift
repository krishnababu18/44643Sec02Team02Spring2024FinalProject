//
//  EventDetailsViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import SDWebImage


class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var dataSV: UIScrollView!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    @IBOutlet var descriptionLbl: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let db = Firestore.firestore()
    var eventDetails: EventModel?
    var eventId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        getEventDetails()
    }
    
    func getEventDetails() -> Void {
        
        dataSV.isHidden = true
        let database = Firestore.firestore()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let docRef = database.collection("Events").document(eventId)
        docRef.getDocument(completion: { snap, error in
            
            guard let data = snap?.data(), error == nil else {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                
                var event = EventModel()
                event.id = snap?.documentID
                event.admin_id = data["admin_id"] as? String ?? ""
                event.image = data["image"] as? String ?? ""
                event.name = data["name"] as? String ?? ""
                event.price = data["price"] as? String ?? ""
                event.location = data["location"] as? String ?? ""
                event.type = data["type"] as? String ?? ""
                
                let a = data["start_date"] as? String ?? ""
                event.start = a
                
                let b = data["end_date"] as? String ?? ""
                event.end = b
                
                event.description = data["description"] as? String ?? ""
                
                self.eventDetails = event
                self.setData()
            }
        })
    }
    
    
    func setData() -> Void {
        
        dataSV.isHidden = false
        
        self.titleLbl.text = eventDetails?.name ?? ""
        let url = eventDetails?.image ?? ""
        imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        
        priceLbl.text = String(format: "$%@", eventDetails?.price ?? "0")
        locationLbl.text = eventDetails?.location ?? ""
        typeLbl.text = String(format: "Type: %@", eventDetails?.type ?? "")
        
        dateLbl.text = String(format: "%@ - %@", eventDetails?.start ?? "", eventDetails?.end ?? "")
        
        
        descriptionLbl.text = eventDetails?.description ?? ""
    }
}
