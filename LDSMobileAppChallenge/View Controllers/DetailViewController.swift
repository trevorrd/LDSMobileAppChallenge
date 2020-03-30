//
//  DetailViewController.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailBirthdateLabel: UILabel!
    @IBOutlet weak var detailForceSensitive: UILabel!
    @IBOutlet weak var detailAffiliationLabel: UILabel!
    
    var individual : Individual?
    let INDIVIDUAL_IMAGE_LOADED_NOTIFICATION = Notification.Name(rawValue: NOTIFICATION_LOADED_IMAGE_KEY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObservers()
        populateDetailData()
    }
    
    // MARK: - Helper Methods
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.reloadImage(notification:)), name: INDIVIDUAL_IMAGE_LOADED_NOTIFICATION, object: nil)
    }
    
    func populateDetailData() {
        guard let individual = individual else { return }
        detailNameLabel.text = individual.firstName + " " + individual.lastName
        detailBirthdateLabel.text = individual.birthdate
        detailForceSensitive.text = "Force Sensitive: \(individual.forceSensitive)"
        detailAffiliationLabel.text = "Affiliation: \(individual.affiliation)"
        
        // Load the detail image
        loadIndividualImage()
    }
    
    func loadIndividualImage() {
        guard let individual = individual else { return }
        guard let individualImageData = individual.profileImage else { return }
        detailImageView.image = UIImage(data: individualImageData)
    }
    
    // MARK: - ObjC Selectors
    
    @objc private func reloadImage(notification: NSNotification) {
        DispatchQueue.main.async {
            self.loadIndividualImage()
        }
    }
    
    // MARK: - Class methods
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

