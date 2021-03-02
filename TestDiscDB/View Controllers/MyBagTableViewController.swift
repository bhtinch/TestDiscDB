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
    
    //  MARK: - Outlets
    
    
    //  MARK: - Properties
    static let shared = MyBagTableViewController()
    
    let userID = Auth.auth().currentUser?.uid ?? "No User"
    var bagID: String?
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNotAuthenticated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDatabaseManager.shared.database.keepSynced(true)
        print("viewWillAppear bagID: \(bagID)")
        if bagID == nil { setBag() }
        tableView.reloadData()
    }
    
    //  MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        AuthManager.shared.logoutUser()
        self.handleNotAuthenticated()
    }
    
    @IBAction func switchBagButtonTapped(_ sender: Any) {
        
    }
    
    //  MARK: - Methods
    func handleNotAuthenticated() {
        if self.userID == "No User" {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    func setBag(){
        let pathString = "\(userID)/\(UserKeys.bags)"
        
        UserDatabaseManager.shared.database.child(pathString).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                if snapshot.hasChildren() == false {
                    self.presentCreateBagAlert()
                }
               
                for child in snapshot.children.allObjects {
                    guard let childSnap = child as? DataSnapshot,
                          let test = childSnap.childSnapshot(forPath: UserKeys.isDefault).value as? Bool else { return }
                    print(test)
                    if test {
                        self.bagID = childSnap.key
                    }
                }
                
                print(self.bagID)
                
                if self.bagID == nil {
                    UserDatabaseManager.shared.database.child(pathString).queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snap) in
                        print(snap.key)
                        for child in snap.children {
                            guard let childSnap = child as? DataSnapshot else { return }
                            let key = childSnap.key as String
                            self.bagID = key
                            print(self.bagID)
                        }
                    }
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
        //guard let bag = self.bagID, bag.discs.count != 0 else { return 0 }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baggedDiscCell", for: indexPath)
        
        //guard let bag = self.bagID else { return UITableViewCell() }
        
        //        cell.textLabel?.text = bag.discs[indexPath.row].model
        //        cell.detailTextLabel?.text = bag.discs[indexPath.row].make
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let bag = self.bagID else { return }
        
        if editingStyle == .delete {
            //BagController.shared.removeDiscFromBag(disc: bag.discs[indexPath.row], bag: bag)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiscDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DiscDetailViewController,
                  let bag = self.bagID else { return }
            //let disc = bag.discs[indexPath.row]
            //.currentBag = bag
            //destination.selectedDisc = disc
        }
        
        if segue.identifier == "toDiscListVC" {
            guard let destination = segue.destination as? DiscListTableViewController,
                  let bag = self.bagID else { return }
            //destination.currentBag = bag
        }
    }
    
}
