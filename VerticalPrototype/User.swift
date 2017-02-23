//
//  User.swift
//  VerticalPrototype
//
//  Created by Austin McInnis on 2/21/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var auth: FIRAuth?
    var user: FIRUser?
    
    init(fUser: FIRUser) {
        self.user = fUser
    }
}
