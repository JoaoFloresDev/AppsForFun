//
//  JobsTableViewCell.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 07/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

//MARK: - PROTOCOL
protocol JobsTableViewCellDelegate {
    func deleteJob(indexPath: IndexPath)
    func finishJob(indexPath: IndexPath)
    func editJob(indexPath: IndexPath)
}

//MARK: - CLASS JobsTableViewCell
class JobsTableViewCell: UITableViewCell {
    
    let ongDM = OrganizationDM()
    
    //MARK: - OUTLETS
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var typeOfJobLabel: UILabel!
    @IBOutlet weak var jobAddressLabel: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var firstVolunteerImage: RoundedImageView!
    @IBOutlet weak var secondVolunteerImage: RoundedImageView!
    @IBOutlet weak var engagedLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var editView: RoundedView!
    
    //MARK: - PROPERTIES
    static let reuseIdentifer = "JobsTableViewCell"
    
    static var nib: UINib {
        let nibName = String(describing: JobsTableViewCell.self)
        return UINib(nibName: nibName, bundle: nil)
    }
    var buttonsAvailable = false {
        didSet {
            if buttonsAvailable { //TODO ajustes
                buttonsView.isHidden = false
                buttonsView.superview?.sizeToFit()
                buttonsView.superview?.superview?.sizeToFit()
                
                if (status ?? false) == false { // if job is finished
                    self.finishView.isHidden = true //shouldn't show Finish button.
                    self.editView.isHidden = true   //shouldn't show Edit button.
                }
            }
        }
    }
    var status: Bool?
    var indexPath: IndexPath?
    var delegate: JobsTableViewCellDelegate?
    
    //MARK: - METHODS
    override func prepareForReuse() {
        self.finishView.isHidden = false
        self.editView.isHidden = false
        self.buttonsView.isHidden = true
    }
    
    func configure(job: Job){
        status = job.status
        
        jobTitleLabel.text = job.title
        jobTitleLabel.numberOfLines = 0
        jobTitleLabel.lineBreakMode = .byWordWrapping
        jobTitleLabel.sizeToFit()
        jobTitleLabel.superview?.sizeToFit()
        
        typeOfJobLabel.text = job.vacancyType
        categoriesLabel.text = job.firstCategoryAndCount
        engagedLabel.text = job.engagedOnesSlashVacancyNumber
        
        if job.address == nil || job.address == "" {
            AddressUtil.recoveryAddress(fromLocation: job.localization, completion: { (result, error) in
                if error == nil {
                    if result != nil {
                        job.address = result
                        self.jobAddressLabel.text = result
                    }
                }
            })
        } else {
            jobAddressLabel.text = job.address
        }
        
        jobAddressLabel.numberOfLines = 0
        jobAddressLabel.lineBreakMode = .byWordWrapping
        jobAddressLabel.sizeToFit()
        jobAddressLabel.superview?.sizeToFit()
        
        
//        ongDM.find(ById: job.organizationID) { (ong, err) in
//            guard let ong = ong else { return }
//            
//            if let avatar = ong.avatar {
//                FileDM().recoverProfileImage(profilePic: avatar) { (image, error) in
//                    guard let image = image else {return}
//                    OperationQueue.main.addOperation {
//                        self.jobImageView.image = image
//                    }
//                }
//            }
//        }
    }
    
    func configIfProfile(delegate: JobsTableViewCellDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.buttonsAvailable = true
    }
    
    //MARK: - ACTIONS
    @IBAction func deletePressed(_ sender: Any) {
        if let indexPath = self.indexPath {
            delegate?.deleteJob(indexPath: indexPath)
        }
    }
    
    @IBAction func finishPressed(_ sender: Any) {
        if let indexPath = self.indexPath {
            delegate?.finishJob(indexPath: indexPath)
        }
    }
    
    @IBAction func editPressed(_ sender: Any) {
        if let indexPath = self.indexPath {
            delegate?.editJob(indexPath: indexPath)
        }
    }
}
