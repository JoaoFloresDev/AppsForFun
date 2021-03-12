//
//  userRegisterViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 28/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class userRegisterViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewVoluntary: UIView!
    @IBOutlet weak var viewOng: UIView!
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewDesign(view: viewVoluntary)
        setupViewDesign(view: viewOng)
    }
    
    //MARK: - SETUP
    func setupViewDesign(view: UIView) {
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = viewVoluntary.frame.size.height/8
        view.clipsToBounds = true
    }
    
    //MARK: - ACTIONS
    @IBAction func actionVoluntary(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUpVoluntary", sender: self)
    }
    
    @IBAction func actionOng(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUpOng", sender: self)
    }
}
