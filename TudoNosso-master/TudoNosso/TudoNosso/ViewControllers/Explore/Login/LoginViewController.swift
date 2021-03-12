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

class LoginViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var constrainTextBox: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var textButtonLogin: UILabel!
    @IBOutlet weak var textButtonRegister: UILabel!
    @IBOutlet weak var textButtonExplore: UIButton!
    @IBOutlet weak var loadIcon: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIcon.alpha = 0
        
        KeyboardAvoiding.avoidingView = self.constrainTextBox
        let colText = UITextField.appearance()
        colText.font = UIFont(name:"Nunito-Bold", size: 14.0)
        textButtonLogin?.font = UIFont(name:"Nunito-Bold", size: 18.0)
        textButtonRegister?.font = UIFont(name:"Nunito-Bold", size: 18.0)
        textButtonExplore.titleLabel?.font = UIFont(name:"Nunito-Bold", size: 18.0)
    }
    
    //MARK: - ALERT
    func showAlert(msg: String, field:UITextField) {
        let alertController = UIAlertController(title: "Campos necessários", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (act) in
            field.becomeFirstResponder()
        }
        
        alertController.addAction(okAction)
        present(alertController,animated: true)
    }
    
    //MARK: - KEYBOARD
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            KeyboardAvoiding.avoidingView = self.constrainTextBox
        } else if textField == self.passwordTextField {
            KeyboardAvoiding.avoidingView = self.constrainTextBox
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - ACTIONS
    @IBAction func signIn(_ sender: Any) {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(msg: "Campo e-mail precisa ser preenchido", field: emailTextField)
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(msg: "Campo senha precisa ser preenchido", field: passwordTextField)
        } else {
            loadIcon.alpha = 1
            loginButton.alpha = 0.5
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  else {return}
            LoginDM().signIn(email: email, pass: password) { (dictionary, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    self.showAlert(msg: "senha ou e-mail incorreta", field: self.passwordTextField)
                    self.loadIcon.alpha = 0
                    self.loginButton.alpha = 1
                } else if let dictionary = dictionary as NSDictionary?  {
                    if let ong = Organization(snapshot: dictionary){
                        Local.userMail = ong.email
                        Local.userKind = LoginKinds.ONG.rawValue
                    } else if let volunteer = Volunteer(snapshot: dictionary){
                        Local.userMail = volunteer.email
                        Local.userKind = LoginKinds.volunteer.rawValue
                    }
                    ViewUtilities.navigateToStoryBoard(storyboardName: "Main", storyboardID: "Tab", window: self.view.window)
                    
                }
            }
        }
    }
    
    @IBAction func returnExplore(_ sender: Any) {
        ViewUtilities.navigateToStoryBoard(storyboardName: "Explore", storyboardID: "Explore", window: self.view.window)
    }
}
