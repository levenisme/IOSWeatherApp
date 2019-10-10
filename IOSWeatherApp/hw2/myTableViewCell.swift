//
//  myTableViewCell.swift
//  hw2
//
//  Created by 邓荔文 on 9/19/19.
//  Copyright © 2019 liwen. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var cities: UILabel!
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var weatherName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }

}
