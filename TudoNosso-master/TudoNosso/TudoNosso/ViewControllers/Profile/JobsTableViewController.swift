//
//  JobsTableViewController.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 18/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {
    
    //MARK: - PROPERTIES
    struct Dependencies {
        var jobs: [Job]
        var isMyProfile: Bool
        
        init(jobs: [Job], isMyProfile: Bool) {
            self.jobs = jobs
            self.isMyProfile = isMyProfile
        }
    }
    
    var jobs: [Job]? {
        didSet {
            sortJobs()
        }
    }
    
    var isMyProfile: Bool?
    
    var ongoingJobs : [Job] = []
    var finishedJobs : [Job] = []
    
    var selectedJob: Job?
    var jobForEdition: Job?
    
    private let jobsDetailSegueID = "toJobDetails"
    private let editJobSegueID = "toEditJob"
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupJobsTableView()
    }
    
    //MARK: - SETUP FROM SEGUE
    func setup(dependencies: Dependencies) {
        self.jobs = dependencies.jobs
        self.isMyProfile = dependencies.isMyProfile
    }
    
    //MARK: - METHODS
    func setupJobsTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.backgroundColor = .clear
        
        tableView.register(JobsTableViewCell.nib, forCellReuseIdentifier: JobsTableViewCell.reuseIdentifer)
        tableView.register(JobsTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: JobsTableViewHeader.reuseIdentifer)
    }
    
    func sortJobs(){
        ongoingJobs.removeAll()
        finishedJobs.removeAll()
        if let jobs = self.jobs {
            for job in jobs {
                if job.status {
                    ongoingJobs.append(job)
                } else {
                    finishedJobs.append(job)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func deleteJob(id: String) {
        let jobDM = JobDM()
        
        jobDM.delete(ById: id)
    }
    
    func finishJob(job: Job) {
        let jobDM = JobDM()
        
        jobDM.save(job: job)
    }
    
    //MARK: - SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case jobsDetailSegueID:
            if let nextVC = segue.destination as? JobViewController {
                nextVC.job = self.selectedJob
            }
        case editJobSegueID:
            if let nextVC = segue.destination as? AddJobTableViewController {
                if let jobForEdition = jobForEdition {
                    nextVC.job = jobForEdition
                }
            }
        default:    break
        }
    }
    
    // MARK: - TABLE VIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: JobsTableViewHeader.reuseIdentifer) as? JobsTableViewHeader else {
            fatalError("The dequeued header is not an instance of JobsTableViewHeader.")
        }
        
        switch section {
        case 0:
            if ongoingJobs.count > 0 {
                header.configure(type: .ongoing)
            } else {
                return nil
            }
        case 1:
            if finishedJobs.count > 0 {
                header.configure(type: .finished)
            } else {
                return nil
            }
        default: break
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if ongoingJobs.count > 0 {
                return JobsTableViewHeader.TypeOfHeader.ongoing.height
            } else { return 0 }
        default:
            if finishedJobs.count > 0 {
                return JobsTableViewHeader.TypeOfHeader.finished.height
            } else { return 0 }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ongoingJobs.count
        default:
            return finishedJobs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.reuseIdentifer, for: indexPath) as? JobsTableViewCell else {
            fatalError("The dequeued cell is not an instance of JobsTableViewCell.")
        }
        switch indexPath.section {
        case 0:
            cell.configure(job: ongoingJobs[indexPath.row])
        default:
            cell.configure(job: finishedJobs[indexPath.row])
        }
        
        if isMyProfile ?? false {
            cell.configIfProfile(delegate: self, indexPath: indexPath)
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.selectedJob = ongoingJobs[indexPath.row]
            self.performSegue(withIdentifier: self.jobsDetailSegueID, sender: nil)
        default:
            return
        }
    }
}

//MARK: - JobsTableViewCellDelegate
extension JobsTableViewController : JobsTableViewCellDelegate {
    func deleteJob(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let id = ongoingJobs[indexPath.row].id {
                deleteJob(id: id)
            }
            self.jobs?.removeAll(where: { (job) -> Bool in
                return job.id == self.ongoingJobs[indexPath.row].id
            })
        case 1:
            if let id = finishedJobs[indexPath.row].id {
                deleteJob(id: id)
            }
            self.jobs?.removeAll(where: { (job) -> Bool in
                return job.id == self.finishedJobs[indexPath.row].id
            })
        default:    break
        }
    }
    
    func finishJob(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let id = ongoingJobs[indexPath.row].id {
                let shouldSort = jobs?.contains(where: { (job) -> Bool in
                    if job.id == id {
                        job.status = false
                        finishJob(job: job)
                        return true
                    } else {
                        return false
                    }
                })
                
                if shouldSort ?? false {
                    sortJobs()
                }
            }
            
        default:    break
        }
    }
    
    func editJob(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            jobForEdition = ongoingJobs[indexPath.row]
        default:    break
        }
        
        performSegue(withIdentifier: editJobSegueID, sender: self)
    }
}
