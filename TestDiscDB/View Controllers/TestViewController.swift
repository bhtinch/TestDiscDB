//
//  TestViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/23/21.
//
import FirebaseDatabase
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doStuff()
    }
    
    func doStuff() {
        database.getData { (error, snap) in
            print(snap.value)
        }
    }
}
