//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Jacob Baca on 9/15/20.
//  Copyright © 2020 Baca Tech. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    //Mark: Properties
    @IBOutlet weak var titleField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
