

//
//  ExploreViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import Photos
import Foundation
import Firebase
import Photos
import FirebaseAuth
//import FIRStorage

class informationsRegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var titleView: UINavigationItem!
    @IBOutlet weak var scrollViewRegister: UIScrollView!
    @IBOutlet weak var constrainTextBox: UIView!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var endressTextBox: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var siteTextBox: UITextField!
    @IBOutlet weak var facebookTextBox: UITextField!
    @IBOutlet weak var constrainViewSite: UIView!
    @IBOutlet weak var labelsite: UILabel!
    @IBOutlet weak var textBoxSite: UITextField!
    @IBOutlet weak var keyTextBox: UITextField!
    @IBOutlet weak var confirmationKeyTextBox: UITextField!
    @IBOutlet weak var constrainViewKey: UIView!
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        delegateDefine()
        
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        KeyboardAvoiding.avoidingView = self.constrainTextBox
    }
    
    //MARK: - METHODS
    fileprivate func delegateDefine() {
        nameTextBox.delegate = self
        endressTextBox.delegate = self
        phoneTextField.delegate = self
        emailTextBox.delegate = self
        descriptionTextBox.delegate = self
        siteTextBox.delegate = self
        facebookTextBox.delegate = self
        keyTextBox.delegate = self
        confirmationKeyTextBox.delegate = self
    }
    
    func signUp() {
        let loginDM = LoginDM()
        
        if(titleView.title == "Cadastro Organização") {
            let organization = Organization(name: nameTextBox.text ?? "", address: CLLocationCoordinate2D(latitude: -10, longitude: 0), desc: descriptionTextBox.text, email: emailTextBox.text ?? "", phone: phoneTextField.text, site: siteTextBox.text ?? "", facebook: facebookTextBox.text, areas: nil, avatar: nil)
            
            loginDM.signUp(email: organization.email, pass: keyTextBox.text!, kind: .ONG, newUserData: organization.representation as NSDictionary) { (login, error) in
                if error != nil {
                    if (error?.localizedDescription ?? "" == "The email address is badly formatted.") {
                        self.showAlert(msg: "E-mail invalido", field: self.nameTextBox)
                    } else {
                        self.showAlert(msg: "Erro: \(error?.localizedDescription ?? "Não identificado")", field: self.emailTextBox)
                    }
                } else {
                    self.performSegue(withIdentifier: "showConfirmRegister", sender: nil)
                }
            }
        } else {
            let volunteer = Volunteer(name: nameTextBox.text ?? "", email: emailTextBox.text ?? "", description: descriptionTextBox.text ?? "")
            
            loginDM.signUp(email: volunteer.email , pass: keyTextBox.text!, kind: .volunteer, newUserData: volunteer.representation as NSDictionary) { (login, error) in
                if error != nil {
                    if (error?.localizedDescription ?? "" == "The email address is badly formatted.") {
                        self.showAlert(msg: "E-mail invalido", field: self.nameTextBox)
                    } else {
                        self.showAlert(msg: "Erro: \(error?.localizedDescription ?? "Não identificado")", field: self.emailTextBox)
                    }
                } else {
                    self.performSegue(withIdentifier: "showConfirmRegister", sender: nil)
                }
            }
        }
    }
    
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
        contentInset.bottom = 700
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
            self.emailTextBox.becomeFirstResponder()
            
        case emailTextBox:
            self.descriptionTextBox.becomeFirstResponder()
            
        case descriptionTextBox:
            self.siteTextBox.becomeFirstResponder()
            
        case siteTextBox:
            self.facebookTextBox.becomeFirstResponder()
            
        case facebookTextBox:
            self.keyTextBox.becomeFirstResponder()
            
        case keyTextBox:
            self.confirmationKeyTextBox.becomeFirstResponder()
            
        default: //confirmationKeyTextBox
            //            KeyboardAvoiding.avoidingView = self.constrainTextBox
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
            vc?.key = keyTextBox.text ?? ""
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func registerAction(_ sender: Any) {
        if nameTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(msg: "Campo Nome precisa ser preenchido", field: nameTextBox)
        } else if (endressTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            showAlert(msg: "Campo Endereço precisa ser preenchido", field: endressTextBox)
        } else if (keyTextBox.text != confirmationKeyTextBox.text) {
            showAlert(msg: "Senhas incompativeis", field: keyTextBox)
        } else if (keyTextBox.text?.count ?? 0 < 6) {
            showAlert(msg: "Sua senha deve possuir 6 digitos ou mais", field: keyTextBox)
        } else {
            let refreshAlert = UIAlertController(title: "Deseja finalizar cadastro?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.signUp()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel cadastro")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}
