//
//  User.swift
//  FireToDo
//
//  Created by Pavel on 5/14/19.
//  Copyright © 2019 Pavel. All rights reserved.
//

import Foundation
import Firebase

struct MyUser {

    let uid: String
    let email: String

    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }

}
