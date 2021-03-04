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
        getData()
    }
    
    var bag: Bag?
    var discs: [String] = []
    
    @IBAction func buttonTapped(_ sender: Any) {
        getData()
    }
    
    func getData() {
        let pathString = "\(UserKeys.userID)/\(UserKeys.bags)"
        
        
        UserDatabaseManager.shared.dbRef.child(pathString).observeSingleEvent(of: .value) { (snap) in
            print(snap.key)
            for child in snap.children {
                guard let childSnap = child as? DataSnapshot else { return }
                let name = childSnap.childSnapshot(forPath: BagKeys.name).value as? String ?? ""
                
                self.discs.append(name)
            }
            self.discNameLabel.text = self.discs[1]
        }
    }
    
    
}   //  End of Class
