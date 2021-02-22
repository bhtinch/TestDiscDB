//
//  DiscListTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//
import FirebaseDatabase
import UIKit

class DiscListTableViewController: UITableViewController {
    
    //  MARK: - Outlets and Properties
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let database = Database.database().reference()
    private var discList: [[String]] = []
    private var filteredDiscList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //  MARK: - Methods
    func getDiscList(searchTerm: String) {
        print("Seraching for \"\(searchTerm)\"...")
        discList = []
        filteredDiscList = []
        
        DispatchQueue.main.async {
            self.database.observeSingleEvent(of: .value) { (snapshot) in
                for index in 0..<snapshot.childrenCount {
                    
                    var disc: [String] = []
                    
                    let make = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Manufacturer Or Distributor").value as? String ?? ""
                    let model = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Disc Model").value as? String ?? ""
                    
                    disc = [make, model]
                    self.discList.append(disc)
                }
                for disc in self.discList {
                    if disc[0].localizedCaseInsensitiveContains(searchTerm) || disc[1].localizedCaseInsensitiveContains(searchTerm) {
                        self.filteredDiscList.append(disc)
                    }
                }
                print(self.filteredDiscList)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDiscList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredDiscList[indexPath.row][1]
        cell.detailTextLabel?.text = self.filteredDiscList[indexPath.row][0]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let disc = filteredDiscList[indexPath.row]
        
        let alertController = UIAlertController(title: "\(disc[1]) by \(disc[0])", message: "Add To Your bag??", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Bag it!", style: .default) { (_) in
            print("bagged")
            Bag.shared.addDiscToBagWith(make: disc[0], model: disc[1])
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension DiscListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped...")
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        self.getDiscList(searchTerm: searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Canceled Search.")
        self.filteredDiscList = []
        self.tableView.reloadData()
    }
}
