//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/14/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messagelbl: UILabel!
    
    func configureCell(profileImage: UIImage, email :String, content: String) {
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.messagelbl.text = content
    }
}
