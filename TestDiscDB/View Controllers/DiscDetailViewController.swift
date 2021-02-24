//
//  DiscDetailViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/24/21.
//

import UIKit

class DiscDetailViewController: UIViewController {
    
    //  MARK: - Properties
    //static let shared = DiscDetailViewController()
    let label = UILabel()
    
    var selectedDisc: Disc? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
   
    
    //  MARK: - Configure Views
    func configureView() {
        self.view.addSubview(label)
        label.frame = CGRect(x: 8, y: 48, width: view.frame.width - 16, height: 24)
        label.textAlignment = .center
        
    }
    
    func updateView() {
        guard let disc = selectedDisc else { return }
        self.label.text = disc.model
    }

}
