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
    var discs: [String] = []
    var discIDs: [String] = []
    var bagID: String = "No Bag"
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Logged In UserID: \(userID)")
        handleNotAuthenticated()
        
        BagManager.getDefaultBag { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bag):
                    print("success")
                    self.title = bag.name
                    self.bagID = bag.uuidString
                    
                    self.discs = []
                    bag.discIDs.values.forEach {
                        self.discs.append($0)
                    }
                    
                    self.discIDs = []
                    bag.discIDs.keys.forEach {
                        self.discIDs.append($0)
                    }
                    
                    self.tableView.reloadData()
                    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        cell.textLabel?.text = discs[indexPath.row]
        cell.detailTextLabel?.text = discIDs[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //code
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiscDetailVC" {
            //guard let indexPath = tableView.indexPathForSelectedRow,
                  //let destination = segue.destination as? DiscDetailViewController,
                  //let bag = self.bagID else { return }
        }
        
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
        
        BagManager.getBagWith(bagID: bagID) { (result) in
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let bag):
                    self.bagID = bag.uuidString
                    
                    self.discs = []
                    bag.discIDs.values.forEach {
                        self.discs.append($0)
                    }
                    
                    self.discIDs = []
                    bag.discIDs.keys.forEach {
                        self.discIDs.append($0)
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    switch error {
                    case .databaseError:
                        print(error)
                    case .noData:
                        self.discs = ["No Discs Yet!"]
                        self.discIDs = [""]
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
