//
//  HomeViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 30/03/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import SDWebImage
import CoreData


class HomeViewController: UIViewController {
    
    @IBOutlet weak var evetnsTV: UITableView!
    @IBOutlet weak var noEventLbl: UILabel!
    
    @IBOutlet weak var weatherLbl: UILabel!
    var favEvents: [EventDB] = []
    var eventsList: [EventModel] = []
    var selectedEvent: EventModel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedType = "Academic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noEventLbl.isHidden = true
        // Do any additional setup after loading the view.
        getWeatherUpdates(for: "Maryville")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.getAllEvents()
    }
    
    
    @IBAction func type(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            selectedType = "Academic"
        }else if sender.selectedSegmentIndex == 1 {
            
            selectedType = "Theators"
        }else if sender.selectedSegmentIndex == 2 {
            
            selectedType = "Sports"
        }
        
        self.getAllEvents()
    }
    
    
    func getAllEvents() -> Void {
        let database = Firestore.firestore()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let docRef = database.collection("Events")
            .whereField("type", isEqualTo: selectedType)
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
                    self.evetnsTV.isHidden = true
                }else {
                    
                    self.noEventLbl.isHidden = true
                    self.evetnsTV.isHidden = false
                }
                
                self.getFavoriteEvents()
                //self.evetnsTV.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeToDetails" {
            
            let vc = segue.destination as! EventDetailsViewController
            vc.eventId = self.selectedEvent?.id ?? ""
            vc.navigationItem.title = self.selectedEvent?.name ?? ""
        }
    }
    
    //MARK: Favorites Events
    func getFavoriteEvents() {
        
        do {
            
            favEvents = try context.fetch(EventDB.fetchRequest())
            self.evetnsTV.reloadData()
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    }
    
    
    @objc func addOrRemoveFav(sender: UIButton) -> Void {
        
        let tag = sender.tag
        let event = eventsList[tag]
        
        let id = event.id
        
        if let index = favEvents.firstIndex(where: { $0.id == id }) {
            //Found
            
            let fav = favEvents[index]
            self.context.delete(fav)
            do {
                
                try context.save()
                self.getFavoriteEvents()
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            //Not Found
            
            let fav = EventDB(context: self.context)
            fav.id = event.id
            fav.name = event.name ?? ""
            fav.desc = event.description ?? ""
            
            do {
                try context.save()
                self.getFavoriteEvents()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeatherUpdates(for city: String) {
            // Construct the URL with proper encoding
            let urlString = "https://wttr.in/\(city.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")?format=%t"
            
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error fetching weather information: \(error)")
                        return
                    }
                    
                    if let data = data, let weatherString = String(data: data, encoding: .utf8) {
                        print("Weather in \(city): \(weatherString)")
                        DispatchQueue.main.async {
                            // Update UI elements here
                            self.weatherLbl.text = "Weather in \(city): \(weatherString)"
                        }
                        
                    } else {
                        print("No data received")
                    }
                }
                task.resume()
            }
        }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        let event = eventsList[indexPath.row]
        
        cell.nameLbl.text = event.name ?? ""
        cell.descLbl.text = event.description ?? ""
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(addOrRemoveFav(sender: )), for: .touchUpInside)
        
        let id = event.id ?? ""
        cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        if let index = favEvents.firstIndex(where: { $0.id == id }) {
            
            cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = eventsList[indexPath.row]
        self.performSegue(withIdentifier: "homeToDetails", sender: self)
    }
}
