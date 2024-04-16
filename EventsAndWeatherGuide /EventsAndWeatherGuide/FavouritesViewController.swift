//
//  FavouritesViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 02/04/2024.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favTV: UITableView!
    @IBOutlet weak var noRecordLbl: UILabel!
    
    var favEvents: [EventDB] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedEvent: EventDB?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favTV.delegate = self
        favTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.getFavoriteEvents()
    }
    
    
    func delete(fav: EventDB) -> Void {
        
        self.context.delete(fav)
        do {
            
            try context.save()
            self.getFavoriteEvents()
        } catch {
            print(error.localizedDescription)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favToDetails" {
            
            let vc = segue.destination as! EventDetailsViewController
            vc.eventId = self.selectedEvent?.id ?? ""
            vc.navigationItem.title = self.selectedEvent?.name ?? ""
        }
    }

    //MARK: Favorites Events
    func getFavoriteEvents() {
        
        do {
            
            favEvents = try context.fetch(EventDB.fetchRequest())
            self.favTV.reloadData()
            
            if favEvents.count == 0 {
                
                noRecordLbl.isHidden = false
                favTV.isHidden = true
            }else {
                
                noRecordLbl.isHidden = true
                favTV.isHidden = false
            }
            
            
        } catch {
            
            print(error.localizedDescription)

        }
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
            
            let event = favEvents[indexPath.row]
            favEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.delete(fav: event)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FavouriteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "favCell") as? FavouriteTableViewCell
        
        let event = self.favEvents[indexPath.row]
        
        cell.nameLbl.text = event.name ?? ""
        cell.descriptionLbl.text = event.desc ?? ""
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = self.favEvents[indexPath.row]
        self.performSegue(withIdentifier: "favToDetails", sender: self)
    }
    
}
