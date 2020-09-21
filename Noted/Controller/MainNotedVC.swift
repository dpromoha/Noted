//
//  MainNotedVC.swift
//  Noted
//
//  Created by Daria Pr on 16.09.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import UIKit
import RealmSwift

class MainNotedVC: UIViewController {
    
    var realm = try! Realm()
    var searchableQuery: Bool = false
    let defaults = UserDefaults.standard
    var result: Results<Notepad>?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        if let colorBar = UserDefaults.standard.color(forKey: "NavBarColor") {
            navigationController?.navigationBar.barTintColor = colorBar
        }
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                self.save(titleInput: textField.text!)
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new note"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - realm
    
    func save(titleInput: String) {
        let title = titleInput
        let id = incrementID()
        let descr = ""
        
        let creation = Notepad(title: title, descr: descr, id: id, dateCreate: Date(), dateModif: Date(), privat: false)
        saveObjects(objs: creation)
        
        tableView.reloadData()
    }
    
    func saveObjects(objs: Object) {
        try? realm.write ({
            realm.add(objs)
        })
    }
    
    func incrementID() -> Int {
        return (realm.objects(Notepad.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

extension MainNotedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchableQuery == false {
            result = realm.objects(Notepad.self).sorted(byKeyPath: "id", ascending: false)
        } else {
            searchableQuery = false
            result = result?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        }
        return result?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainNotes", for: indexPath) as? MainCell else {return UITableViewCell()}
        
        let rowItem = result?[indexPath.row]
        
        cell.titleLabel!.text = rowItem?.title
        let dateFormatter = DateFormatter()
        let date = rowItem?.dateModif
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy HH:mm")
        
        cell.dateLabel!.text = dateFormatter.string(from: date ?? Date())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if result?[indexPath.row].privat == true {
            performSegue(withIdentifier: "privateSegue", sender: self)
        } else {
            performSegue(withIdentifier: "textNote", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let objectToDelete = self.result?[indexPath.row]
            try! realm.write {
                realm.delete(objectToDelete!)
            }
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let selectedNote: Notepad! = self.result?[selectedRow]
            switch segue.identifier! {
            case "textNote":
                let destinationVC = segue.destination as? TextVC
                destinationVC?.structNote = selectedNote
            case "privateSegue":
                let destinationVC = segue.destination as? PrivateTextVC
                destinationVC?.structNote = selectedNote
            default:
                print("Fatal Error: no segue")
            }
        }
    }
}

extension MainNotedVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchableQuery = true
        result = result?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            result = realm.objects(Notepad.self).sorted(byKeyPath: "id", ascending: false)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
