//
//  AdminEventTableViewCell.swift
//  EventsAndWeatherGuide
//
//  Created by Gattineni manideep on 01/04/2024.
//

import UIKit

class AdminEventTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var datesLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
