//
//  AllEventsViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import SDWebImage
import AVFoundation

class AllEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noEventLbl: UILabel!
    
    
    var eventsList: [EventModel] = []
    var selectedEvent: EventModel?
    
    @IBOutlet weak var eventsTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventsTV.delegate = self
        eventsTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedEvent = nil
        self.getAllEvents()
    }
    
    func deleteEvent(id: String) -> Void {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Events").document(id)
        docRef.delete() { err in
            if let _ = err {
                
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.getAllEvents()
            }
        }
        AudioServicesPlaySystemSound(1155)
    }
    
    
    func getAllEvents() -> Void {
        let database = Firestore.firestore()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let docRef = database.collection("Events")
            .whereField("admin_id", isEqualTo: id)
        docRef.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                
                print("Error getting documents: \(err)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            } else {
                
                self.eventsList.removeAll()
                MBProgressHUD.hide(for: self.view, animated: true)
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    
                    var event = EventModel()
                    event.id = document.documentID
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
                    
                    self.eventsList.append(event)
                }
                
                if self.eventsList.count == 0 {
                    
                    self.noEventLbl.isHidden = false
                    self.eventsTV.isHidden = true
                }else {
                    
                    self.noEventLbl.isHidden = true
                    self.eventsTV.isHidden = false
                }
                
                self.eventsTV.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addOrUpdate" {
            
            let vc = segue.destination as! AddOrUpdateEventViewController
            vc.eventDetails = self.selectedEvent
        }
    }
    
    @IBAction func add(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addOrUpdate", sender: self)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let event = eventsList[indexPath.row]
            eventsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.deleteEvent(id: event.id ?? "")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AdminEventTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "adminEventCell") as? AdminEventTableViewCell
        
        let event = self.eventsList[indexPath.row]
        
        cell.nameLbl.text = event.name ?? ""
        cell.priceLbl.text = String(format: "$%@", event.price ?? "0")
        
        let url = event.image ?? ""
        cell.imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo"))
        
        cell.locationLbl.text = String(format: "%@", event.location ?? "")

        let start = event.start ?? ""
        let end = event.end ?? ""
    
        
        cell.datesLbl.text = String(format: "%@ - %@", start, end)
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = self.eventsList[indexPath.row]
        self.performSegue(withIdentifier: "addOrUpdate", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.synchronize()
        
        do {
            
            try Auth.auth().signOut()
        } catch {}
        
        
        self.performSegue(withIdentifier: "adminToLogin", sender: self)
    }
    
    
}
