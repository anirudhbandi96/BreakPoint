//
//  FeedCell.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/12/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

   
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    
    func configureCell(profileImg: UIImage, email: String, content: String){
        
        self.profileImg.image = profileImg
        self.usernameLbl.text = email
        self.contentLbl.text = content
        
    }
}
