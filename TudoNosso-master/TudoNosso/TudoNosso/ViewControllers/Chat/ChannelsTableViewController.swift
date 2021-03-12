//
//  ChannelsTableViewController.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class ChannelsTableViewController:  UITableViewController {
    //MARK: - Properties
    var channels: [Channel] = []{
        didSet{
            tableView.reloadData()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: IBOutlet's
    @IBOutlet var channelsTableView: UITableView!
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChannelTableViewCell.nib, forCellReuseIdentifier: ChannelTableViewCell.reuseIdentifer)
        
        setupNavegationBar()
        loadChannels()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChannels()
    }
    
    // MARK: - TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifer, for: indexPath) as? ChannelTableViewCell else {
            fatalError("The dequeued cell is not an instance of JobsTableViewCell.")
        }
        cell.configure(channel: channels[indexPath.row])
        
        return cell
    }
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChannel(self.channels[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    fileprivate func openChannel(_ channel: Channel) {
        let userID = Base64Converter.encodeStringAsBase64(Local.userMail!)
        let userKind = LoginKinds(rawValue: Local.userKind!)!
        LoginDM().recoverUser(ById: userID, onKind: userKind) { (dictionary, err) in
            if err == nil {
                guard
                    let dictionary = dictionary,
                    let user = User(snapshot: dictionary as NSDictionary)
                    else {return}
                let vc = ChatViewController(user: user, channel: channel )
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func loadChannels(){
        if Local.userKind != nil {
            ChannelDM().listAll { (channels, err) in
                guard let channels = channels else {return}
                self.channels = channels
            }
        }
    }
    func setupNavegationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFFFFFF, a: 1)
        navigationController?.navigationBar.barStyle = .black
    }
}
