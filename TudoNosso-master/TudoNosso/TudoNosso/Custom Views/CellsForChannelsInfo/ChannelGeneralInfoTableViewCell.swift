//
//  ChannelGeneralInfoTableViewCell.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 25/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class ChannelGeneralInfoTableViewCell: UITableViewCell {
    
    static let reuseIdentifer = "ChannelGeneralInfoTableViewCell"
    static var nib: UINib {
        let nibName = String(describing: ChannelGeneralInfoTableViewCell.self)
        return UINib(nibName: nibName, bundle: nil)
    }
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var ongNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(channel:Channel){
        OperationQueue.main.addOperation {
            self.chatNameLabel.text = channel.name
            self.ongNameLabel.text = ""
        }
    }
    func configure(user:User){
        OperationQueue.main.addOperation {
            self.ongNameLabel.text = user.displayName
        }
    }
}
