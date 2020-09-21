//
//  TextVC.swift
//  Noted
//
//  Created by Daria Pr on 16.09.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import UIKit
import RealmSwift
import LocalAuthentication

class TextVC: UIViewController, UITextViewDelegate {
    
    var realm = try! Realm()
    var structNote: Notepad = Notepad()
    let context: LAContext = LAContext()
    var pr: Bool = false
    var i: Int = 0
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
    }
    
    @IBAction func privateNote(_ sender: UIBarButtonItem) {
        print("LOCKED")
        i+=1
        
        if i % 2 != 0 {
            pr = true
        } else {
            pr = false
        }
        
        try! realm.write {
            structNote.privat = pr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleField.text = structNote.title
        textView.text = structNote.descr
        
        let today = structNote.dateModif
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        dateLabel.text = formatter3.string(from: today)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let title = String(titleField.text!)
        let noteDescription = String(textView.text!)
        
        try! realm.write {
            structNote.title = title
            structNote.descr = noteDescription
            structNote.dateModif = Date()
            structNote.privat = pr
            print("SAVE")
        }
    }
}
