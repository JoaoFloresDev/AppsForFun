//
//  ProfileViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    @IBOutlet weak var addJobLabelView: UIView!
    @IBOutlet weak var editLabelView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var loggoutButton: UIBarButtonItem!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var jobsContainerView: UIView!
    
    //MARK: - PROPERTIES
    private let jobsSegueID = "toJobsTable"
    private let profileSegueID = "toProfileTable"
    private let addJobSegueID = "toAddJob"
    private let EditProfileSegueID = "toEditProfile"
    
    var email: String?
    
    struct Data {
        var name: String?
        var address: CLLocationCoordinate2D?
        var email: String?
        var description: String?
        var phone: String?
        var site: String?
        var facebook: String?
        var areas: [String]?
        var avatar: String?
        var typeOfProfile: TypeOfProfile?
    }
    
    var profileData: Data? {
        didSet {
            if self.shouldPerformSegue(withIdentifier: self.profileSegueID, sender: self) {
                self.performSegue(withIdentifier: self.profileSegueID, sender: self)
            }
        }
    }
    
    var jobs : [Job]? {
        didSet {
            if self.shouldPerformSegue(withIdentifier: self.jobsSegueID, sender: self) {
                self.performSegue(withIdentifier: self.jobsSegueID, sender: self)
            }
        }
    }
    
    enum TypeOfProfile {
        case ong(Bool)
        case volunteer
        
        var isAddJobButtonHidden: Bool {
            switch self {
            case let .ong(myProfile):          return !myProfile
            case .volunteer:                 return true
            }
        }
        
        var segmentedControlTitle: String {
            switch self {
            case .ong:          return "Oportunidades"
            case .volunteer:    return "Participações"
            }
        }
        
        var isSegmentedControlHidden: Bool {
            switch self {
            case .ong:          return false
            case .volunteer:    return true
            }
        }
        
        var aboutTitle: String {
            switch self {
            case .ong:          return "Sobre a ONG"
            case .volunteer:    return "Sobre mim"
            }
        }
        
        var isAreasFieldHidden: Bool {
            switch self {
            case .ong:      return false
            default:        return true
            }
        }
    }
    
    var typeOfProfile: TypeOfProfile? {
        didSet{
            //TODO changes according to type of profile
            self.addJobLabelView.isHidden = typeOfProfile?.isAddJobButtonHidden ?? true
            self.buttonView.isHidden = typeOfProfile?.isAddJobButtonHidden ?? true
        
            self.segmentedControl.setTitle(typeOfProfile?.segmentedControlTitle ?? "", forSegmentAt: 0)
            self.segmentedControl.isHidden = typeOfProfile?.isSegmentedControlHidden ?? false
            if typeOfProfile?.isSegmentedControlHidden ?? false {
                self.jobsContainerView.isHidden = true
                self.profileContainerView.isHidden = false
                
                self.addJobLabelView.isHidden = true
                self.editLabelView.isHidden = !isMyProfile
               
            }
            
        }
    }
    var isMyProfile = false{
        didSet{
            if isMyProfile{
                let loggout = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: Selector(("logout")))
                self.navigationItem.rightBarButtonItem = loggout
            }
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove border from nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - METHODS
    func loadData() {
        let loginDM = LoginDM()
        let jobDM = JobDM()
        
        var emailAddress: String! = ""
        if self.email != nil {
            emailAddress = self.email
            isMyProfile = emailAddress == Local.userMail
        } else {
            emailAddress = Local.userMail
            isMyProfile = true
        }
        
        loginDM.find(ByEmail: emailAddress) { (result, error) in
            if let erro = error {
                print(erro.localizedDescription)
            } else {
                guard let login = result else {return}
                switch login.kind {
                case LoginKinds.ONG:
                    self.typeOfProfile = .ong(self.isMyProfile)
                    
                    let orgDM = OrganizationDM()
                    
                    orgDM.find(ByEmail: emailAddress) { (result, error) in
                        if let erro = error {
                            print(erro.localizedDescription)
                        } else {
                            guard let ong = result else {return}
                            self.profileData = Data(name: ong.name,
                                                    address: ong.address,
                                                    email: ong.email,
                                                    description: ong.desc,
                                                    phone: ong.phone,
                                                    site: ong.site,
                                                    facebook: ong.facebook,
                                                    areas: ong.areas,
                                                    avatar: ong.avatar,
                                                    typeOfProfile: self.typeOfProfile)
                            self.profileNameLabel.text = ong.name
                        }
                    }
                    
                    let id = Base64Converter.encodeStringAsBase64(emailAddress)
                    
                    jobDM.find(inField: .organizationID, withValueEqual: id) { (result, error) in
                        if let erro = error {
                            print(erro.localizedDescription)
                        } else {
                            guard let jobs = result else {return}
                            self.jobs = jobs
                        }
                    }
                    
                case LoginKinds.volunteer:
                    self.typeOfProfile = .volunteer
                    
                    let volunteerDM = VolunteerDM()
                    
                    volunteerDM.find(ByEmail: emailAddress) { (result, error) in
                        if let erro = error {
                            print(erro.localizedDescription)
                        } else {
                            guard let volunteer = result else {return}
                            self.profileData = Data(name: volunteer.name,
                                                    address: nil,
                                                    email: volunteer.email,
                                                    description: volunteer.description,
                                                    phone: nil,
                                                    site: nil,
                                                    facebook: nil,
                                                    areas: nil,
                                                    avatar: nil,
                                                    typeOfProfile: self.typeOfProfile)
                            self.profileNameLabel.text = volunteer.name
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - SEGUES
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier{
        case profileSegueID:
            if self.profileData != nil {
                return true
            } else {
                return false
            }
        case jobsSegueID:
            if self.jobs != nil {
                return true
            } else {
                return false
            }
        default:    return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is EditProfileViewController {
            let vc = segue.destination as? EditProfileViewController
            
            vc?.name = profileData?.name ?? ""
            vc?.phone = profileData?.phone ?? ""
            vc?.email = profileData?.email ?? ""
            vc?.descriptionText = profileData?.description ?? ""
            vc?.facebook = profileData?.facebook ?? ""
            vc?.webSite = profileData?.site ?? ""
        }
        
        switch segue.identifier {
        case profileSegueID:
            if let nextVC = segue.destination as? ProfileTableViewController {
                nextVC.receivedData = self.profileData
            }
        case jobsSegueID:
            if let nextVC = segue.destination as? JobsTableViewController {
                let dependencies = JobsTableViewController.Dependencies(jobs: self.jobs ?? [], isMyProfile: self.isMyProfile)
                nextVC.setup(dependencies: dependencies)
            }
        default:    break
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // show jobs
            self.jobsContainerView.isHidden = false
            self.profileContainerView.isHidden = true
            
            self.addJobLabelView.isHidden = typeOfProfile?.isAddJobButtonHidden ?? true
            self.editLabelView.isHidden = true
        case 1: // show profile
            self.jobsContainerView.isHidden = true
            self.profileContainerView.isHidden = false
            
            self.addJobLabelView.isHidden = true
            self.editLabelView.isHidden = !isMyProfile
        default:
            break
        }
    }
    
    @IBAction func addJobPressed(_ sender: Any) {
        performSegue(withIdentifier: addJobSegueID, sender: self)
    }
    
    @IBAction func editProfilePressed(_ sender: Any) {
        print("edit profile pressed")
        if(UserDefaults.standard.string(forKey: "USER_KIND") ?? "0" == "ong") {
            self.performSegue(withIdentifier: self.EditProfileSegueID, sender: self)
        } else {
            self.performSegue(withIdentifier: self.EditProfileSegueID, sender: self)
        }
    }
    
    @objc func logout(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("erro ao deslogar")
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "USER_MAIL")
        defaults.removeObject(forKey: "USER_KIND")
        defaults.synchronize()
        
        ViewUtilities.navigateToStoryBoard(storyboardName: "Explore", storyboardID: "Explore", window: self.view.window)
    }
}
