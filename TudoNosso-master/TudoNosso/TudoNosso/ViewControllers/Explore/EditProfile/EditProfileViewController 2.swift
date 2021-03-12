//
//  EditProfileViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import Photos
import Foundation
import Firebase
import Photos
import FirebaseAuth

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var scrollViewRegister: UIScrollView!
    @IBOutlet weak var constrainTextBox: UIView!
    @IBOutlet weak var endressTextBox: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var faceBookTextBox: UITextField!
    @IBOutlet weak var webSiteTextBox: UITextField!
    
    //MARK: - PROPERTIES
    var name = ""
    var endress = ""
    var phone = ""
    var email = ""
    var descriptionText = ""
    var facebook = ""
    var webSite = ""
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataText()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        delegateDefine()
        KeyboardAvoiding.avoidingView = self.constrainTextBox
    }
    
    //MARK: - METHODS
    fileprivate func delegateDefine() {
        nameTextBox.delegate = self
        endressTextBox.delegate = self
        phoneTextField.delegate = self
        emailTextBox.delegate = self
        descriptionTextBox.delegate = self
        faceBookTextBox.delegate = self
        webSiteTextBox.delegate = self
    }
    
    fileprivate func loadDataText() {
        nameTextBox.text = name
        endressTextBox.text = endress
        phoneTextField.text = phone
        emailTextBox.text = email
        descriptionTextBox.text = descriptionText
        faceBookTextBox.text = facebook
        webSiteTextBox.text = webSite
    }
    
    func updateData() {
        if let userType = Local.userKind {
            
            if (userType == LoginKinds.ONG.rawValue) {
                let organizationDM = OrganizationDM()
                let organization = Organization(name: name, address: CLLocationCoordinate2D(latitude: -10, longitude: 0), desc: descriptionTextBox.text, email: email, phone: phoneTextField.text, site: webSiteTextBox.text, facebook: faceBookTextBox.text, areas:[], avatar: nil)
                
                organizationDM.save(ong: organization)
            } else {
                let volunteerDM = VolunteerDM()
                let volunteer = Volunteer(name: nameTextBox.text ?? "", email:email, description: descriptionTextBox.text)
                
                volunteerDM.save(volunteer: volunteer)
            }
        }
    }
    
    //MARK: - ALERT
    func showAlert(msg: String, field:UITextField) {
        let alertController = UIAlertController(title: "Preenchimento incorreto", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
            field.becomeFirstResponder()
        }
        alertController.addAction(okAction)
        present(alertController,animated: true)
    }
    
    //MARK: - KEYBOARD
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var contentInset:UIEdgeInsets = self.scrollViewRegister.contentInset
        contentInset.bottom = 600
        scrollViewRegister.contentInset = contentInset
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case nameTextBox:
            self.endressTextBox.becomeFirstResponder()
            
        case endressTextBox:
            self.phoneTextField.becomeFirstResponder()
            
        case phoneTextField:
            self.descriptionTextBox.becomeFirstResponder()
            
        case descriptionTextBox:
            self.faceBookTextBox.becomeFirstResponder()
            
        case faceBookTextBox:
            self.webSiteTextBox.becomeFirstResponder()
            
        default:
            var contentInset:UIEdgeInsets = self.scrollViewRegister.contentInset
            contentInset.bottom = -5
            scrollViewRegister.contentInset = contentInset
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ConfirmRegisterViewController {
            let vc = segue.destination as? ConfirmRegisterViewController
            vc?.email = emailTextBox.text ?? ""
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func closeEdition(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if nameTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(msg: "Campo Nome precisa ser preenchido", field: nameTextBox)
        } else if (endressTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            showAlert(msg: "Campo Endereço precisa ser preenchido", field: endressTextBox)
        } else {
            let refreshAlert = UIAlertController(title: "Deseja finalizar cadastro?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("atualizar dados")
                self.updateData()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel cadastro")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}

