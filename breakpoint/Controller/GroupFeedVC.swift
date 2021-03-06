//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/14/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    

    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group){
        self.group = group
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //sendBtnView.bindToKeyboard()
        self.view.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (emailArray) in
            self.membersLbl.text = emailArray.joined(separator: ",")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0{
                    print("yup")
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count-1, section:0), at: .bottom, animated: true)
                }
            })
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (success) in
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    
                }
            })
        }
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row].content
        DataService.instance.getUsername(forUID: groupMessages[indexPath.row].senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message)
            }
        
        return cell
        
    }
}




















