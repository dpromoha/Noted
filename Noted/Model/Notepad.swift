//
//  Notepad.swift
//  Noted
//
//  Created by Daria Pr on 16.09.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import Foundation
import RealmSwift

class Notepad: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descr: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var dateCreate: Date = Date()
    @objc dynamic var dateModif: Date = Date()
    @objc dynamic var privat: Bool = false

    convenience init(title: String, descr: String, id: Int, dateCreate: Date, dateModif: Date, privat: Bool) {
       
        self.init()
        
        self.title = title
        self.descr = descr
        self.id = id
        self.dateCreate = dateCreate
        self.dateModif = dateModif
        self.privat = privat
    }
}
