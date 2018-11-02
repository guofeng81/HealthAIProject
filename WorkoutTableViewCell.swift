//
//  WorkoutTableViewCell.swift
//  
//
//  Created by Naresh Kumar on 31/10/18.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    

    @IBOutlet weak var strengthLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var middleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!


    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
