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
    private var user: FIRUser?
    
    init() {
        auth = FIRAuth.auth()
        user = auth?.currentUser
    }
}
