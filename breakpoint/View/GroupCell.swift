//
//  GroupCell.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/14/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescLbl: UILabel!
    @IBOutlet weak var memberCountLbl: UILabel!
    
    func configureCell(title: String, desc: String, memberCount: Int){
        self.groupTitleLbl.text = title
        self.groupDescLbl.text = desc
        self.memberCountLbl.text = "\(memberCount) members."
    }
}
