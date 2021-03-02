//
//  SwitchBagTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 3/1/21.
//

import UIKit
import FirebaseDatabase

protocol SwitchBagTableViewDelegate: AnyObject {
    func send(bagID: String)
}

class SwitchBagTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDatabaseManager.shared.database.keepSynced(true)
        getBaglist()
    }
    
    var bags: [[String]] = []
    weak var delegate: SwitchBagTableViewDelegate?
    
    func getBaglist() {
        let pathString = "\(UserKeys.userID)/\(UserKeys.bags)"
        
        UserDatabaseManager.shared.database.child(pathString).observeSingleEvent(of: .value) { (snap) in
            DispatchQueue.main.async {
                for child in snap.children {
                    guard let childSnap = child as? DataSnapshot else { return }
                    let bagID = childSnap.key as String
                    let bagName  = childSnap.childSnapshot(forPath: BagKeys.name).value as? String ?? "Unnamed"
                    
                    let bag = [bagName, bagID]
                    self.bags.append(bag)
                }
                print(self.bags)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchBagCell", for: indexPath)
        
        let bagName = bags[indexPath.row][0]
        cell.textLabel?.text = bagName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bagID = self.bags[indexPath.row][1]
        delegate?.send(bagID: bagID)
        navigationController?.popViewController(animated: true)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}   //  End of Class
