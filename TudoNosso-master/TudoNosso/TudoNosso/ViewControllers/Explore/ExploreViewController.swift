//
//  ExploreViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

class ExploreViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var labelButtonLogin: UILabel!
    @IBOutlet weak var buttonAreaImage: UIImageView!
    
    //MARK: - PROPERTIES
    var selectedCause: String = ""
    var selectedOrganization: String = ""
    var selectedJob: Int = 0
    var organizationsList : [Organization] = []
    var filteredOrganizationsList : [Organization] = []
    var filteredOngoingJobs : [Job] = []
    let categories = ["Causas", "Organizações", "Todas as Vagas"]
    var searchController = UISearchController(searchResultsController: nil)
    var organization : Organization = Organization(name: "", address: CLLocationCoordinate2D(), email: "")
    var jobs : [Job] = []
    var backgroundQueue: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }
    
    //MARK: IBAction
    @IBAction func actionButtonLogin(_ sender: Any) {
        if let kind = Local.userKind{
            if(kind == LoginKinds.ONG.rawValue) {
                self.performSegue(withIdentifier: "ShowAddJob", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar(searchBarDelegate: self, searchResultsUpdating: self, jobsTableView, searchController)
        setupJobsTableView()
        setupNavegationBar()
        //        loadData()
        
        if let kind = Local.userKind,
            let tipoLogin = LoginKinds(rawValue: kind) {
            switch tipoLogin {
            case .ONG:
                labelButtonLogin.text = "Criar vaga"
            case .volunteer:
                buttonLogin.alpha = 0
                labelButtonLogin.alpha = 0
                buttonAreaImage.alpha = 0
            }
        }else {
            labelButtonLogin.text = "Cadastrar ou fazer login"
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
        
        // remove border from nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: setups
    func setupNavegationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFFFFFF, a: 1)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupJobsTableView() {
        jobsTableView.isHidden = false
        jobsTableView.backgroundColor = .clear
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        jobsTableView.register(JobsTableViewCell.nib, forCellReuseIdentifier: JobsTableViewCell.reuseIdentifer)
        jobsTableView.register(JobsTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: JobsTableViewHeader.reuseIdentifer)
    }
    
    func setupTableView(){
        jobsTableView.backgroundColor = .clear
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
    }
    
    //MARK: - FILTER
    private func filterJobs(for searchText: String) {
        filteredOngoingJobs = jobs.filter { player in
            return player.title.lowercased().contains(searchText.lowercased())
        }
        jobsTableView.reloadData()
    }
    
    private func filterOrganizations(for searchText: String) {
        filteredOrganizationsList = organizationsList.filter { player in
            return player.name.lowercased().contains(searchText.lowercased())
        }
        jobsTableView.reloadData()
    }
    
    //MARK: LOADER
    func loadData() {
        let jobDM = JobDM()
        jobDM.find(inField: .status, withValueEqual: true, completion: { (result, error) in
            guard let result = result else { return }
            self.jobs = result
            self.jobsTableView.reloadData()
        })
        
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CategoryOportunitiesViewController {
            let vc = segue.destination as? CategoryOportunitiesViewController
            vc?.titleHeader = selectedCause
        } else if segue.destination is JobViewController {
            if let vc = segue.destination as? JobViewController,
                let selectedJob = sender as? Job {
                vc.job = selectedJob
            }
        } else if segue.destination is ProfileViewController {
            if let vc = segue.destination as? ProfileViewController{
                vc.email = selectedOrganization
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ExploreViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterJobs(for: searchController.searchBar.text ?? "")
        filterOrganizations(for: searchController.searchBar.text ?? "")
    }
    
    func isSearchControllerActiveAndNotEmpty() -> Bool {
        return (searchController.isActive && searchController.searchBar.text != "")
    }
}

// MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //focus in
        isDarkStatusBar = true
    }
}

// MARK: - UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        let selectedJob = jobs[indexPath.row]
        self.performSegue(withIdentifier: "showDetailSegue", sender: selectedJob)
    }
}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        
        if (section == 0) {
            myLabel.frame = CGRect(x: 10, y: 20, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            
        } else if (section == 1) {
            myLabel.frame = CGRect(x: 10, y: 0, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        } else {
            myLabel.frame = CGRect(x: 10, y: -5, width: 320, height: 40)
            myLabel.font = UIFont(name:"Nunito-Bold", size: 18.0)
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        }

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchControllerActiveAndNotEmpty() {
            return filteredOngoingJobs.count
        }
        if section < 2 {
            return 1
        } else {
            return jobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchControllerActiveAndNotEmpty() {
            return categories[2]
        }
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchControllerActiveAndNotEmpty() {
            return 1
        }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var typeCell = indexPath.section
        
        if isSearchControllerActiveAndNotEmpty() {
            typeCell = 2
        }
        
        switch typeCell {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell") as! CategoryCollectionView
            cell.tag = 0
            cell.delegate = self
            cell.organizationsList = organizationsList
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "cell2") as! CategoryCollectionView
            cell.tag = 1
            cell.delegate = self
            cell.loadDataOrganizations()
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.reuseIdentifer, for: indexPath) as? JobsTableViewCell else {
                fatalError("The dequeued cell is not an instance of JobsTableViewCell.")
            }
            
            let job: Job
            
            if isSearchControllerActiveAndNotEmpty() {
                job = filteredOngoingJobs[indexPath.row]
            } else {
                job = jobs[indexPath.row]
            }
            
            let imageDownloadOperation = BlockOperation {
                OrganizationDM().find(ById: job.organizationID) { (ong, err) in
                    guard let ong = ong,
                        let avatar = ong.avatar
                        else { return }
                    FileDM().recoverProfileImage(profilePic: avatar) { (image, error) in
                        guard let image = image else {return}
                        OperationQueue.main.addOperation {
                            cell.jobImageView.image = image
                        }
                    }
                }
            }
            
            self.backgroundQueue.addOperation(imageDownloadOperation)
            
            cell.configure(job: job)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CategoryCollectionViewDelegate
extension ExploreViewController: CategoryCollectionViewDelegate {
    func causeSelected(_ view: CategoryCollectionView, causeTitle: String?, OrganizationEmail: String?,tagCollection: Int) {
        
        if(tagCollection == 0) {
            if let title = causeTitle {
                self.selectedCause = title
            }
            self.performSegue(withIdentifier: "showCauses", sender: self)
        } else {
            if let title = OrganizationEmail {
                self.selectedOrganization = title
            }
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
    }
}



