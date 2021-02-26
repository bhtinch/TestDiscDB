//
//  MyBagTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//
import FirebaseAuth
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleNotAuthenticated()
    }
    
    //  MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        AuthManager.shared.logoutUser { (loggedOut) in
            if loggedOut {
                print("firebase user logged out")
                self.handleNotAuthenticated()
            } else {
                print("firebase user could not be logged out.")
            }
        }
    }
    
    
    //  MARK: - Methods
    func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
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
