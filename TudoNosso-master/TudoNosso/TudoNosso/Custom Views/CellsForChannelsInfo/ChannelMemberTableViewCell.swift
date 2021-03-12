//
//  ChannelMemberTableViewCell.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 25/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class ChannelMemberTableViewCell: UITableViewCell {
    static let reuseIdentifer = "ChannelMemberTableViewCell"
    static var nib: UINib {
        let nibName = String(describing: ChannelMemberTableViewCell.self)
        return UINib(nibName: nibName, bundle: nil)
    }
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var memberKindLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(user:User){
        OperationQueue.main.addOperation {
            self.memberNameLabel.text = user.displayName
            
            if let kind = user.kind { self.memberKindLabel.text = NSLocalizedString(kind, comment: "")
            }
        }
    }
}
