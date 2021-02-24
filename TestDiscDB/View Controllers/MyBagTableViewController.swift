//
//  MyBagTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//

import UIKit

class MyBagTableViewController: UITableViewController {
    
    static let shared = MyBagTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bag.shared.loadFromPersistenceStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Bag.shared.myBag.count == 0 {
            return 0
        } else {
            return Bag.shared.myBag.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baggedDiscCell", for: indexPath)

        cell.textLabel?.text = Bag.shared.myBag[indexPath.row].model
        cell.detailTextLabel?.text = Bag.shared.myBag[indexPath.row].make
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Bag.shared.removeDiscFromBag(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiscDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DiscDetailViewController else { return }
                  let disc = Bag.shared.myBag[indexPath.row]
            destination.selectedDisc = disc
        }
    }
}
