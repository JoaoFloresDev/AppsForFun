//
//  ChannelTableViewCell.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelNameLabel: UILabel!
    
    static let reuseIdentifer = "ChannelTableViewCell"
    
    static var nib: UINib {
        let nibName = String(describing: ChannelTableViewCell.self)
        return UINib(nibName: nibName, bundle: nil)
    }
    
    func configure(channel: Channel){
        self.channelNameLabel.text = "Chat: \(channel.name)"
    }
}
