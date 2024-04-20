//
//  AddOrUpdateEventViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import UIKit
import Eureka
import MBProgressHUD
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

class AddOrUpdateEventViewController: FormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage

        if let image = image {
            
            self.selectedImage = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    var selectedImage: UIImage?
    var imageURL = ""
    
    var eventDetails: EventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Event"
        
        form +++ Section("Event Details")
        <<< buttonRow(for: "Select Image", tag: "imageRow")
        <<< TextRow("nameRow") { row in
            row.title = "Name"
        }
        <<< DecimalRow("priceRow") { row in
            row.title = "Price"
        }
        <<< TextRow("locationRow") { row in
            row.title = "Location"
        }
        <<< DateRow("startDateRow") { row in
            row.title = "Start Date"
        }
        <<< DateRow("endDateRow") { row in
            row.title = "End Date"
        }
        <<< PushRow<String>("popupButtonRow") { row in
            row.title = "Category"
            row.options = ["Academic", "Theators", "Sports"]
            row.value = row.options?.first
        }
        <<< TextAreaRow("descriptionRow") { row in
            row.title = "Description"
                row.placeholder = "Enter description"
        }
        
        
        if self.eventDetails != nil {
            
            self.setData()
        }
        
        
        form +++ Section()
        <<< ButtonRow("saveButtonRow") { row in
            row.title = "Save"
            row.onCellSelection { _, _ in
                self.saveButtonPressed()
            }
        }
    }

    
    func setData() -> Void {
        
        DispatchQueue.main.async {
                // Update text rows
            
            if let imageRow = self.form.rowBy(tag: "imageRow") as? ButtonRow {
                
                imageRow.cellStyle = .value1
                imageRow.cellUpdate { cell, row in
                        // Set details label text
                        cell.detailTextLabel?.text = "Image Selected"
                    }
                imageRow.updateCell()
            }
            
            if let nameRow = self.form.rowBy(tag: "nameRow") as? TextRow {
                        nameRow.value = self.eventDetails?.name as? String
                        nameRow.updateCell()
                    }
            
            if let priceRow = self.form.rowBy(tag: "priceRow") as? DecimalRow {
                        priceRow.value = Double(self.eventDetails?.price as? String ?? "0")
                        priceRow.updateCell()
                    }
            
            if let locationRow = self.form.rowBy(tag: "locationRow") as? TextRow {
                        locationRow.value = self.eventDetails?.location as? String
                        locationRow.updateCell()
                    }
            
            if let descriptionRow = self.form.rowBy(tag: "descriptionRow") as? TextAreaRow {
                        descriptionRow.value = self.eventDetails?.description as? String
                        descriptionRow.updateCell()
                    }
            
            //self.form.rowBy(tag: "nameRow")?.baseValue = self.eventDetails?.name as? String
            //self.form.rowBy(tag: "priceRow")?.baseValue = Double(self.eventDetails?.price as? String ?? "0")
            //self.form.rowBy(tag: "locationRow")?.baseValue = self.eventDetails?.location as? String
            //self.form.rowBy(tag: "descriptionRow")?.baseValue = self.eventDetails?.description as? String
                
            let dtFormatter = DateFormatter()
            dtFormatter.dateFormat = "dd/MM/yyyy"
            
            let start = self.eventDetails?.start ?? ""
            let start_date = dtFormatter.date(from: start)
            
            let end = self.eventDetails?.end ?? ""
            let end_date = dtFormatter.date(from: end)
            
            
            if let startDateRow = self.form.rowBy(tag: "startDateRow") as? DateRow {
                        startDateRow.value = start_date
                        startDateRow.updateCell()
                    }
            
            if let endDateRow = self.form.rowBy(tag: "endDateRow") as? DateRow {
                        endDateRow.value = end_date
                        endDateRow.updateCell()
                    }
            
                // Update date rows
                //self.form.rowBy(tag: "startDateRow")?.baseValue = start_date
                //self.form.rowBy(tag: "endDateRow")?.baseValue = end_date
                
            
            if let popupButtonRow = self.form.rowBy(tag: "popupButtonRow") as? PushRow<String> {
                        popupButtonRow.value = self.eventDetails?.type as? String
                        popupButtonRow.updateCell()
                    }
            
                // Update push row
            //self.form.rowBy(tag: "popupButtonRow")?.baseValue = self.eventDetails?.type as? String
                
            }
    }
    
    func buttonRow(for title: String, tag: String) -> ButtonRow {
            return ButtonRow(tag) { row in
                row.title = title
                row.cellStyle = .value1
                row.onCellSelection { _, _ in
                    self.presentImagePicker()
                }
                }.cellUpdate { cell, _ in
                    cell.detailTextLabel?.text = self.selectedImage != nil ? "Image Selected" : ""
            }
        }
        
        func presentImagePicker() {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
                
                self.selectImageFromGallery()
                
                
            }))

            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                
                self.takeImageFromCamera()
                
                
            }))

            self.present(actionSheet, animated: true)
        }
        
        func saveButtonPressed() {
            // Check if any required field is empty
            
            if eventDetails != nil {
                
                if selectedImage == nil {
                    
                    self.imageURL = self.eventDetails?.image ?? ""
                    
                    if isAnyRequiredFieldEmpty() {
                        showAlert(message: "Please fill in all required fields.")
                        return
                    }
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.updateEvent()
                    
                }else {
                    
                    if self.isAnyRequiredFieldEmpty() {
                        self.showAlert(message: "Please fill in all required fields.")
                        return
                    }
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.uploadProfileImage {
                        
                        
                        self.updateEvent()
                    }
                }
            }else {
                
                if selectedImage == nil {
                    
                    showAlert(message: "Please select image.")
                }else{
                    
                    if self.isAnyRequiredFieldEmpty() {
                        self.showAlert(message: "Please fill in all required fields.")
                        return
                    }
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.uploadProfileImage {
                        self.saveEvent()
                    }
                }
            }
        }
    
    func uploadProfileImage(completion: @escaping () -> ()) {
        
        var imageData:Data = selectedImage!.pngData()! as Data
        if imageData.count <= 0 {
            
            imageData = selectedImage!.jpegData(compressionQuality: 1.0)! as Data
        }
        
        let uid = UUID()
        let name = "\(uid).png"
        
        let storageRef = Storage.storage().reference().child("\(name)")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("error")
                MBProgressHUD.hide(for: self.view, animated: true)
                completion()
                
            } else {
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    let str = url?.absoluteString
                    self.imageURL = str ?? ""
                    completion()
                })
            }
        }
    }
    
    func updateEvent() -> Void {
        
        let name_Str = form.rowBy(tag: "nameRow")?.baseValue as? String ?? ""
            
            let price = form.rowBy(tag: "priceRow")?.baseValue as? Double ?? 0
            
            let location = form.rowBy(tag: "locationRow")?.baseValue as? String ?? ""
            
            // Get the values of date rows
            let startDate = form.rowBy(tag: "startDateRow")?.baseValue as? Date ?? Date()
            
             let endDate = form.rowBy(tag: "endDateRow")?.baseValue as? Date ?? Date()
            
            // Get the value of the push row
            let popupButtonValue = form.rowBy(tag: "popupButtonRow")?.baseValue as? String ?? "Sports"
            
            // Get the value of the text area row
            let description = form.rowBy(tag: "descriptionRow")?.baseValue as? String ?? ""
        
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dtFormatter.string(from: startDate)
        let end_str = dtFormatter.string(from: endDate)
        
        let params = ["admin_id": id,
                      "name": name_Str,
                      "type": popupButtonValue,
                      "price": String(format: "%0.2f", price),
                      "image": imageURL,
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": description,
                      "location": location]
        

        let path = String(format: "%@", "Events")
        let db = Firestore.firestore()
        let doc_id = eventDetails?.id ?? ""
        
        db.collection(path).document(doc_id).updateData(params) { err in
            if let err = err {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlert(message: err.localizedDescription)

            } else {

                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "", message: "Event updated successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in

                    // do something like...
                    self.navigationController?.popViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func saveEvent() -> Void {
        
        let name_Str = form.rowBy(tag: "nameRow")?.baseValue as? String ?? ""
            
            let price = form.rowBy(tag: "priceRow")?.baseValue as? Double ?? 0
            
            let location = form.rowBy(tag: "locationRow")?.baseValue as? String ?? ""
            
            // Get the values of date rows
            let startDate = form.rowBy(tag: "startDateRow")?.baseValue as? Date ?? Date()
            
             let endDate = form.rowBy(tag: "endDateRow")?.baseValue as? Date ?? Date()
            
            // Get the value of the push row
            let popupButtonValue = form.rowBy(tag: "popupButtonRow")?.baseValue as? String ?? "Sports"
            
            // Get the value of the text area row
            let description = form.rowBy(tag: "descriptionRow")?.baseValue as? String ?? ""
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dtFormatter.string(from: startDate)
        let end_str = dtFormatter.string(from: endDate)
        
        let params = ["admin_id": id,
                      "name": name_Str,
                      "type": popupButtonValue,
                      "price": String(format: "%0.2f", price),
                      "image": imageURL,
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": description,
                      "location": location]
        

        let path = String(format: "%@", "Events")
        let db = Firestore.firestore()

        db.collection(path).document().setData(params) { err in
            if let err = err {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlert(message: err.localizedDescription)

            } else {

                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "", message: "Event added successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in

                    // do something like...
                    self.navigationController?.popViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)
            }
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

    func selectImageFromGallery() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }

    func takeImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        self.present(imagePicker, animated: true)
    }
    
    func isAnyRequiredFieldEmpty() -> Bool {
        let requiredFields: [String] = ["nameRow", "priceRow", "locationRow", "startDateRow", "endDateRow", "descriptionRow"]
        
        
        for tag in requiredFields {
            guard let row = form.rowBy(tag: tag), let value = row.baseValue else {
                return true // Row not found or value is nil
            }
            
            if let stringValue = value as? String, stringValue.isEmpty {
                return true // String value is empty
            }
            
            if let dateValue = value as? Date, dateValue.timeIntervalSince1970 == 0 {
                return true // Date value is not set
            }
            
            if let doubleValue = value as? Double, doubleValue == 0 {
                return true // Double value is 0
            }
        }
        
        return false
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        AudioServicesPlaySystemSound(1151)
    }
}
