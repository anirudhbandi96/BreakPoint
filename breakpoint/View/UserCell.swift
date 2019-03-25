//
//  UserCell.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/13/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    var showing = false
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var checkImg: UIImageView!
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool ){
        self.profileImg.image = image
        self.emailLbl.text = email
        self.checkImg.isHidden = isSelected ? false : true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if (showing == false) {
            self.checkImg.isHidden = false
            showing = true
            } else {
            self.checkImg.isHidden = true
            showing = false
        }
    }

}

}
