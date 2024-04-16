//
//  AddOrUpdateEventViewController.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MBProgressHUD

class AddOrUpdateEventViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var dateMainView: UIView!
    
    @IBOutlet weak var dtPicker: UIDatePicker!
    
    var dateField = ""
    var imageURL = ""
    var selectedImage: UIImage?
    var eventDetails: EventModel?
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.clipsToBounds = true
        
        
        dtPicker.minimumDate = Date()
        
        descTV.text = "Write description"
        descTV.textColor = .lightGray
        descTV.delegate = self
        descTV.layer.cornerRadius = 8
        descTV.layer.borderWidth = 1
        descTV.layer.borderColor = UIColor.opaqueSeparator.cgColor
        
        dateMainView.isHidden = true
        
        typeBtn.titleLabel?.text = "Category"
        typeBtn.menu = UIMenu(children: [
            UIAction(title: "Academic", handler: { _ in
                
            }),
            UIAction(title: "Theators", handler: { _ in
                
            }),
            UIAction(title: "Sports", handler: { _ in
                
            })
        ])
        typeBtn.showsMenuAsPrimaryAction = true
        
        
        self.navigationItem.title = "Add Event"
        if eventDetails != nil {
            
            self.navigationItem.title = "Update Event"
            self.setData()
        }
    }
    
    func setData() -> Void {
        
        let url = eventDetails?.image ?? ""
        imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "photo")) { img, error, cahce, url in
        }
        
        nameTF.text = eventDetails?.name ?? ""
        priceTF.text = eventDetails?.price ?? ""
        locationTF.text = eventDetails?.location ?? ""
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start = eventDetails?.start ?? ""
        let start_date = dtFormatter.date(from: start)
        self.startDate = start_date
        
        let end = eventDetails?.end ?? ""
        let end_date = dtFormatter.date(from: end)
        self.endDate = end_date
        
        dtFormatter.dateFormat = "MMM dd, yyyy"
        
        startBtn.setTitle(dtFormatter.string(from: start_date ?? Date()), for: .normal)
        endBtn.setTitle(dtFormatter.string(from: end_date ?? Date()), for: .normal)
        
        typeBtn.setTitle(eventDetails?.type, for: .normal)
        
        
        descTV.text = eventDetails?.description
        descTV.textColor = .black
        
        saveBtn.setTitle("Update", for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func selectImgBtn(_ sender: Any) {
        
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
    
    
    @IBAction func startBtn(_ sender: Any) {
        
        dtPicker.maximumDate = nil
        
        dateMainView.isHidden = false
        dateField = "start"
    }
    
    @IBAction func endBtn(_ sender: Any) {
        
        if startDate != nil {
            
            dtPicker.minimumDate = startDate
        }
        
        dateMainView.isHidden = false
        dateField = "end"
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if self.validateData() {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if eventDetails != nil {
                
                if selectedImage == nil {
                    
                    self.imageURL = self.eventDetails?.image ?? ""
                    self.updateEvent()
                    
                }else {
                    
                    self.uploadProfileImage {
                        
                        self.updateEvent()
                    }
                }
            }else {
                
                self.uploadProfileImage {
                    
                    self.saveEvent()
                }
            }
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        dateMainView.isHidden = true
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        dateMainView.isHidden = true
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "MMM dd, yyyy"
        
        if dateField == "start" {
            
            startDate = dtPicker.date
            let date_str = dtFormatter.string(from: startDate!)
            startBtn.setTitle(date_str, for: .normal)
            
            endDate = nil
            endBtn.setTitle("End Date", for: .normal)
            
        }else {
            
            endDate = dtPicker.date
            let date_str = dtFormatter.string(from: endDate!)
            endBtn.setTitle(date_str, for: .normal)
        }
    }
    
    
    func saveEvent() -> Void {
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dtFormatter.string(from: startDate!)
        let end_str = dtFormatter.string(from: endDate!)
        
        let params = ["admin_id": id,
                      "name": nameTF.text!,
                      "type": typeBtn.titleLabel?.text ?? "",
                      "price": String(format: "%@", priceTF.text!),
                      "image": imageURL,
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": descTV.text!,
                      "location": locationTF.text!]
        

        let path = String(format: "%@", "Events")
        let db = Firestore.firestore()

        db.collection(path).document().setData(params) { err in
            if let err = err {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showMsg(msg: err.localizedDescription)

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
    
    
    func updateEvent() -> Void {
        
        let id = Auth.auth().currentUser?.uid ?? ""
        
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "dd/MM/yyyy"
        
        let start_str = dtFormatter.string(from: startDate!)
        let end_str = dtFormatter.string(from: endDate!)
        
        let params = ["admin_id": id,
                      "name": nameTF.text!,
                      "type": typeBtn.titleLabel?.text ?? "",
                      "price": String(format: "%@", priceTF.text!),
                      "image": imageURL,
                      "start_date": start_str,
                      "end_date": end_str,
                      "description": descTV.text!,
                      "location": locationTF.text!]
        

        let path = String(format: "%@", "Events")
        let db = Firestore.firestore()
        let doc_id = eventDetails?.id ?? ""
        
        db.collection(path).document(doc_id).updateData(params) { err in
            if let err = err {

                MBProgressHUD.hide(for: self.view, animated: true)
                self.showMsg(msg: err.localizedDescription)

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
    
    
    func validateData() -> Bool {
        
        if selectedImage == nil && eventDetails == nil {
            
            self.showMsg(msg: "Image is required")
            return false
        }else if nameTF.text == "" {
            
            self.showMsg(msg: "Name is required")
            return false
        }else if priceTF.text == "" {
            
            self.showMsg(msg: "Price is required")
            return false
        }else if locationTF.text == "" {
            
            self.showMsg(msg: "Location is required")
            return false
        }else if startDate == nil {
            
            self.showMsg(msg: "Start Date is required")
            return false
        }else if endDate == nil {
            
            self.showMsg(msg: "End Date is required")
            return false
        }else if descTV.text == "Write description" {
            
            self.showMsg(msg: "Description is required")
            return false
        }
        
        return true
    }
    
    
    func showMsg(msg: String) -> Void {
        
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddOrUpdateEventViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage

        if let image = image {
            
            self.imgView.image = image
            self.selectedImage = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AddOrUpdateEventViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Write description"
            textView.textColor = .lightGray
        }
    }
}
