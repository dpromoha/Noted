//
//  PrivateTextVC.swift
//  Noted
//
//  Created by Daria Pr on 18.09.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import UIKit
import RealmSwift
import LocalAuthentication

class PrivateTextVC: UIViewController {
    
    var realm = try! Realm()
    var structNote: Notepad = Notepad()
    var test = true

    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var warningButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLbl.text = "BLOCKED"
        warningButton.setTitle("Touch to open", for: .normal)
        warningButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    @IBAction func openBlockedNote(_ sender: UIButton) {
        
        let context: LAContext = LAContext()
        
        if test == true {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To open a note") { (good, error) in
                    if good {
                        self.test = false
                        DispatchQueue.main.async {
                            self.warningLbl.text = "OPENED"
                            self.warningButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                        }
                    } else {
                        self.test = true
                        print("error")
                    }
                }
            }
        } else {
            performSegue(withIdentifier: "privateTextSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? TextVC
        destinationVC?.structNote = structNote
    }
}
