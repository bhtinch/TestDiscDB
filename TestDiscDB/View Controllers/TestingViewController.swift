//
//  TestingViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/27/21.
//
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class TestingViewController: UIViewController {
    @IBOutlet weak var bagnNameLabel: UILabel!
    @IBOutlet weak var discNameLabel: UILabel!
    @IBOutlet weak var discBrandLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let storeRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var bag: Bag?
    var discs: [String] = []
    
    @IBAction func buttonTapped(_ sender: Any) {
        getData()
    }
    @IBAction func pickImageButtonTapped(_ sender: Any) {
        let vc = ImagePickerViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
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

extension TestingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
            if let jpegData = image.jpegData(compressionQuality: 1) {
                self.storeRef.child(Auth.auth().currentUser?.uid ?? "user").child("pic1").putData(jpegData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
