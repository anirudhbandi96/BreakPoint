//
//  DataService.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/3/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance  = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS : DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED : DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String , userData: Dictionary<String,Any>){
        
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
        
        if groupKey != nil{
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content":message,"senderId":uid])
            sendComplete(true)
        }else {
            REF_FEED.childByAutoId().updateChildValues(["content":message,"senderId":uid])
            sendComplete(true)
        }
        
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()){
        
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot{
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                
                messageArray.append(Message(content: content, senderId: senderId))
            }
            
            handler(messageArray)
            
        }
        
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messages:[Message]) -> ()){
        
        var groupMessagesArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessagesSnapshot) in
            guard let groupMessagesSnapshot = groupMessagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessagesSnapshot{
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                groupMessagesArray.append(Message(content: content, senderId: senderId))
        }
            
            handler(groupMessagesArray)
        
    }
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray:[String]) -> ()){
        var emailArray = [String]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
                
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsernames usernames:[String], handler: @escaping (_ ids:[String])->()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            var ids = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    ids.append(user.key)
                }
            }
            handler(ids)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids:[String], handler: @escaping (_ groupCreated: Bool)->()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title":title,"description":description,"members":ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group])->()){
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let desc = group.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, desc: desc, key: group.key, mcount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
                
            }
            handler(groupsArray)
        }
        
    }
    func getEmailsFor(group: Group, handler: @escaping (_ emails: [String]) -> ()) {
        
        REF_USERS.observeSingleEvent(of: .value) { (usersDataSnapshot) in
            var emailArray = [String]()
            guard let usersDataSnapshot = usersDataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in usersDataSnapshot {
                if group.members.contains(user.key){
                    emailArray.append(user.childSnapshot(forPath: "email").value as! String)
                }
            }
            handler(emailArray)
        }
    }
    
}
