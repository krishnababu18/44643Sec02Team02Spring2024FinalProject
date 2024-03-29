import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var sendLinkButton: UIButton! // Connect this outlet to your "Send Link" button
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initially disable the "Send Link" button
        sendLinkButton.isEnabled = false
        
        // Add a target to the email text field to call a function when the text changes
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    // Function to validate email address format and enable/disable the button accordingly
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if let email = textField.text {
            // Enable the button if the email is in proper format, disable otherwise
            sendLinkButton.isEnabled = isValidEmail(email)
        }
    }
    
    // Function to validate email address format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
