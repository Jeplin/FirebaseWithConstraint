//
//  users.swift
//  FirebaseDBDemo
//
//  Created by Jeplin on 31/10/18.
//  Copyright © 2018 Jeplin. All rights reserved.
//

import Foundation


class Users{
    var id:String!
    var name:String?
    var message:String?
    
    init(id:String?,name:String?,message:String?) {
        self.id=id
        self.name=name
        self.message=message
    }
    
}
