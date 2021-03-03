//
//  DiscListTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//
import UIKit
import FirebaseDatabase

class DiscListTableViewController: UITableViewController {
    
    //  MARK: - Outlets and Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    var filteredDiscModelList: [String] = []
    var filteredDiscBrandList: [String] = []
    
    var currentBagID: String?
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    //  MARK: - Methods
    /// Attempts to filter the entire disc database and return all discs that contain the searchTerm (case insensitive) in  'model' or 'Manufacturer Or Distributor'
    func filterDiscList(searchTerm: String) {
        print("Seraching for \"\(searchTerm)\"...")
        filteredDiscModelList = []
        filteredDiscBrandList = []
        
        DiscDatabaseManager.shared.database.observeSingleEvent(of: .value) { (snap) in
            DispatchQueue.main.async {
                for child in snap.children.allObjects {
                    let childSnap = child as? DataSnapshot
                    
                    let discModel = childSnap?.childSnapshot(forPath: DiscKeys.model).value as? String ?? ""
                    let discBrand = childSnap?.childSnapshot(forPath: DiscKeys.brand).value as? String ?? ""
                    
                    if discModel.localizedCaseInsensitiveContains(searchTerm) {
                        self.filteredDiscModelList.append(discModel)
                        self.filteredDiscBrandList.append(discBrand)
                    }
                    
                    if discBrand.localizedCaseInsensitiveContains(searchTerm) {
                        self.filteredDiscModelList.append(discModel)
                        self.filteredDiscBrandList.append(discBrand)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func presentAddDiscAlertWith(disc: Disc) {
        let alertController = UIAlertController(title: "\(disc.model) by \(disc.make)", message: "Add To Your bag??", preferredStyle: .alert)
        
//        let addAction = UIAlertAction(title: "Bag it!", style: .default) { (_) in
//            guard let bag = self.currentBag else { return }
//            BagController.shared.addDiscToBagWith(disc: disc, bag: bag)
//            print("bagged")
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        let showDetailAction = UIAlertAction(title: "Disc Details", style: .default) { (_) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "DiscDetailViewController") as? DiscDetailViewController else { return }
            
            controller.selectedDisc = disc

            self.present(controller, animated: true, completion: nil)
        }
        
        //alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        alertController.addAction(showDetailAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentRemoveDiscsFromOtherBagsWith(disc: Disc) {
        //  BagController.shared.removeDiscFromBag   loop through bags and compare if current bag or something
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDiscModelList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredDiscModelList[indexPath.row]
        cell.detailTextLabel?.text = self.filteredDiscBrandList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let disc = filteredDiscList[indexPath.row]
        //presentAddDiscAlertWith(disc: disc)
        //presentRemoveDiscsFromOtherBagsWith(disc: disc)
    }
}   //  End of Class

extension DiscListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped...")
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        self.filterDiscList(searchTerm: searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Canceled Search.")
        searchBar.text = ""
        self.filteredDiscBrandList = []
        self.filteredDiscModelList = []
        self.tableView.reloadData()
    }
}   //  End of Extension
