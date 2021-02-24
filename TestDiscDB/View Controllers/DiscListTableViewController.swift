//
//  DiscListTableViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//
import UIKit

class DiscListTableViewController: UITableViewController {
    
    //  MARK: - Outlets and Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    private var filteredDiscList: [Disc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        LocalDatabase.shared.loadFromPersistenceStore()
        
        if LocalDatabase.shared.localDatabase.isEmpty {
            LocalDatabase.shared.syncDatabase { (result) in
                switch result {
                case .success(let message):
                    print(message)
                case .failure(let error):
                    return print(error.localizedDescription)
                }
            }
        }
    }
    
    //  MARK: - Actions
    @IBAction func syncButtonTapped(_ sender: Any) {
        LocalDatabase.shared.syncDatabase { (result) in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                return print(error.localizedDescription)
            }
        }
        self.tableView.reloadData()
    }
    
    //  MARK: - Methods
    func filterDiscList(searchTerm: String) {
        print("Seraching for \"\(searchTerm)\"...")
        filteredDiscList = []
        
        DispatchQueue.main.async {
            for disc in LocalDatabase.shared.localDatabase {
                if disc.model.localizedCaseInsensitiveContains(searchTerm) || disc.make.localizedCaseInsensitiveContains(searchTerm) {
                    self.filteredDiscList.append(disc)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDiscList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredDiscList[indexPath.row].model
        cell.detailTextLabel?.text = self.filteredDiscList[indexPath.row].make
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let disc = filteredDiscList[indexPath.row]
        
        let alertController = UIAlertController(title: "\(disc.model) by \(disc.make)", message: "Add To Your bag??", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Bag it!", style: .default) { (_) in
            print("bagged")
            Bag.shared.addDiscToBagWith(disc: disc)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        let showDetailAction = UIAlertAction(title: "Disc Details", style: .default) { (_) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "DiscDetailViewController") as? DiscDetailViewController else { return }
            
            controller.selectedDisc = disc

            self.present(controller, animated: true, completion: nil)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        alertController.addAction(showDetailAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension DiscListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped...")
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        self.filterDiscList(searchTerm: searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Canceled Search.")
        self.filteredDiscList = []
        self.tableView.reloadData()
    }
}
