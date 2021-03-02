//
//  CreateNewBagViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/26/21.
//

import UIKit

class CreateNewBagViewController: UIViewController {
    
    static let shared = CreateNewBagViewController()
    
    //  MARK: - outlets
    @IBOutlet weak var bagNameTextField: UITextField!
    @IBOutlet weak var bagBrandTextField: UITextField!
    @IBOutlet weak var bagModelTextField: UITextField!
    @IBOutlet weak var bagColorTextField: UITextField!
    @IBOutlet weak var uncheckedButton: UIButton!
    @IBOutlet weak var checkedButton: UIButton!
    @IBOutlet weak var defaultStackView: UIStackView!
    
    var isDefault: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkedButton.isHidden = true
    }
    
    //  MARK: - Actions
    @IBAction func uncheckedButtonTapped(_ sender: Any) {
        checkedButton.isHidden = false
        isDefault = true
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkedButton.isHidden = true
        isDefault = false
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
//        guard let name = bagNameTextField.text, !name.isEmpty else { return }
//        let brand = bagBrandTextField?.text ?? "null"
//        let model = bagModelTextField?.text ?? "null"
//        let color = bagColorTextField?.text ?? "null"
//
//        UserDatabaseManager.shared.addUserBagWith(name: name, brand: brand, model: model, color: color, isDefault: isDefault)
//        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
