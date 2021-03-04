//
//  MyBagTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//
import FirebaseAuth
import FirebaseDatabase
import UIKit

class MyBagTableViewController: UITableViewController {
    
    //  MARK: - Properties
    static let shared = MyBagTableViewController()
    var userID = Auth.auth().currentUser?.uid ?? "No User"
    var discs: [Disc] = []
    var discIDs: [String] = []
    var bagID: String = "No Bag"
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Logged In UserID: \(userID)")
        handleNotAuthenticated()
        
        fetchDefaultBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        fetchBag(bagID: bagID)
    }
    
    //  MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        AuthManager.shared.logoutUser()
        self.userID = "No User"
        self.handleNotAuthenticated()
    }
    
    //  MARK: - Methods
    func handleNotAuthenticated() {
        if self.userID == "No User" {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    func fetchDefaultBag() {
        BagManager.getDefaultBag { (result) in
            switch result {
            case .success(let bag):
                print("successfully fetched Bag with ID: \(bag.uuidString)")
                self.title = bag.name
                self.bagID = bag.uuidString
                
                self.discIDs = []
                bag.discIDs.keys.forEach {
                    self.discIDs.append($0)
                }
                self.fetchDiscs()
                
            case .failure(let error):
                switch error {
                case .databaseError:
                    print(error)
                case .noData:
                    self.presentCreateBagAlert()
                }
            }
        }
    }
    
    func fetchBag(bagID: String) {
        BagManager.getBagWith(bagID: bagID) { (result) in
            
            switch result {
            case .success(let bag):
                self.bagID = bag.uuidString
                
                self.discIDs = []
                bag.discIDs.keys.forEach {
                    self.discIDs.append($0)
                }
                
                self.fetchDiscs()
                
            case .failure(let error):
                switch error {
                case .databaseError:
                    print(error)
                case .noData:
                    self.discs = []
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchDiscs() {
        self.discs = []
        
        for uid in discIDs {
            DiscDatabaseManager.shared.getDiscWith(uid: uid) { (result) in
                switch result {
                case .success(let disc):
                    self.discs.append(disc)
                    
                    if uid == self.discIDs.last {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func presentCreateBagAlert() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateNewBagViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baggedDiscCell", for: indexPath)
        
        cell.textLabel?.text = discs[indexPath.row].model
        cell.detailTextLabel?.text = discs[indexPath.row].make
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let discID = discIDs[indexPath.row]
            BagManager.removeDiscWith(discID: discID, fromBagWith: bagID)
            fetchBag(bagID: bagID)
        }
    }
    
    //  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDiscDetailVC" {
//            guard let indexPath = tableView.indexPathForSelectedRow,
//            let destination = segue.destination as? DiscDetailViewController,
//            let bag = self.bagID else { return }
//        }
        
        if segue.identifier == "toDiscListVC" {
            guard let destination = segue.destination as? DiscListTableViewController else { return }
            destination.currentBagID = self.bagID
        }
        
        if segue.identifier == "toSwitchBagTVC" {
            guard let destination = segue.destination as? SwitchBagTableViewController else { return }
            destination.delegate = self
        }
    }
    
}   //  End of Class


//  MARK: - Extensions
extension MyBagTableViewController: SwitchBagTableViewDelegate {
    func send(bagID: String, bagName: String) {
        print("Selected Bag Name: \(bagName)")
        print("Selected Bag ID: \(bagID)")
        self.title = bagName
        self.bagID = bagID
    }
}
