//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/13/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var chosenArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.emailSearchTextField.delegate = self
        self.emailSearchTextField.addTarget(self, action: #selector(CreateGroupsVC.textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.doneBtn.isHidden = true
    }
    
    @objc func textFieldDidChange(){
        if emailSearchTextField.text == ""{
            self.emailArray = []
            self.tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (emailArray) in
                self.emailArray = emailArray
                self.tableView.reloadData()
            })
        }
        
    }

    @IBAction func doneBtnWasPressed(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextField.text != "" {
            DataService.instance.getIds(forUsernames: chosenArray, handler: { (ids) in
                var userIds = ids
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: userIds, handler: { (success) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("group could not be created. Please try again.")
                    }
                })
                
            })
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CreateGroupsVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let image = UIImage(named: "defaultProfileImage")
        if chosenArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenArray.contains(cell.emailLbl.text!){
            chosenArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = chosenArray.joined(separator: ",")
            self.doneBtn.isHidden = false
            
        } else {
            chosenArray = chosenArray.filter({ $0 != cell.emailLbl.text!})
            if chosenArray.count >= 1 {
                groupMemberLbl.text = chosenArray.joined(separator: ",")
            } else{
                self.groupMemberLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    
    
    
}
