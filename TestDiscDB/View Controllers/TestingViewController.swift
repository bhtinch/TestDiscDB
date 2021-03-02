//
//  TestingViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/27/21.
//
import FirebaseAuth
import FirebaseDatabase
import UIKit

class TestingViewController: UIViewController {
    @IBOutlet weak var bagnNameLabel: UILabel!
    @IBOutlet weak var discNameLabel: UILabel!
    @IBOutlet weak var discBrandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.keepSynced(true)
        getData()
        
    }
    
    let database = Database.database(url: "https://testdiscdb-users-rtdb.firebaseio.com/").reference()
    var bagID: String = "bagID1"
    var userID: String = "0"
    
    @IBAction func buttonTapped(_ sender: Any) {
        getData()
    }
    
    func getData() {
        // ultimately will likely use ids to get USER, BAG, RACK, and/or DISCS
        // so, the line code below will probably look like...
        // let userID = Auth.auth().currentUser.uid
        // var bagID: String? - landing pad for selected bag
        // let pathString = "\(userID)/\(UserKeys.shared.bags)/\(bagID)"
        // then grab all data from that bag using snap.childSnapshot(forPath: "name) as example
        // then grab all discs and loop through to pass to an array... then can use array to populate TableView
        
        let bagPath = "\(userID)/bags/\(bagID)"
        
        let bagSnap = self.database.child(bagPath).observeSingleEvent(of: .value) { (snap) in
            DispatchQueue.main.async {
                self.bagnNameLabel.text = snap.childSnapshot(forPath: "name").value as? String ?? ""
                self.discNameLabel.text = snap.childSnapshot(forPath: "discs").childSnapshot(forPath: "discID1").childSnapshot(forPath: "name").value as? String ?? ""
            }
        }
    }
    
}   //  End of Class
