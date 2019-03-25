//
//  Group.swift
//  breakpoint
//
//  Created by Anirudh Bandi on 2/14/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation


class Group {
    private var _groupTitle : String
    private var _groupDesc : String
    private var _key: String
    private var _memberCount: Int
    private var _members: [String]
    
    var groupTitle: String{
        return self._groupTitle
    }
    
    var groupDesc: String {
        return self._groupDesc
    }
    
    var key: String{
        return self._key
    }
    var memberCount: Int{
        return self._memberCount
    }
    var members: [String] {
        return self._members
    }
    
    init(title: String, desc: String, key: String, mcount : Int, members: [String]){
        self._groupTitle = title
        self._groupDesc = desc
        self._key = key
        self._memberCount = mcount
        self._members = members
    }
    
}
