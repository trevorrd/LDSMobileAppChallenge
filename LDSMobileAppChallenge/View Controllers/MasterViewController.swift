//
//  MasterViewController.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let INDIVIDUAL_IMAGE_LOADED_NOTIFICATION = Notification.Name(rawValue: NOTIFICATION_LOADED_IMAGE_KEY)
    var detailViewController: DetailViewController? = nil
    var individuals : [Individual]?
    
    // MARK: - UIView methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!loadIndividualsFromCoreData()) {
            callWebService()
        }
    }
    
    // MARK: - Helper Methods
    
    func loadIndividualsFromCoreData() -> Bool {
        self.individuals = PersistenceService.loadIndividualData()
        guard let individuals = self.individuals else {
            return false
        }
        if individuals.count < 1 {
            return false
        }
        
        return true
    }
    
    func callWebService() {
        let webService = HttpCaller(urlString: URL_WEBSERVICE_MAIN_ENDPOINT, method: .GET)
        webService.callBackProtocol = self
        webService.getRemoteResponse(ofType: [String : [Individual]].self)
    }
    
    func callImageWebServices() {
        guard let individuals = self.individuals else { return }
        
        for individual in individuals {
            let webServiceCall = HttpCaller(urlString: individual.profilePicture, method: .GET)
            webServiceCall.imageCallbackProtocol = self
            webServiceCall.getImageResponse(for : individual.id )
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                guard let individuals = individuals else { return }
                controller.individual = individuals[indexPath.row]
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let individuals = self.individuals else { return 0 }
        return individuals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? IndividualTableViewCell else { return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)}
        
        guard let individuals = self.individuals else { return cell }
        cell.cellIndividual = individuals[indexPath.row]
        cell.setupCellData()
        
        return cell
    }
}

extension MasterViewController : CallbackProtocol {
    func dataLoadedSuccessfully(withData: Decodable?) {
        if let receivedData = withData as? [ String : [Individual]] {
            self.individuals = receivedData["individuals"]
        } else {
            print("ReceivedData didn't come back as expected!")
        }
        
        DispatchQueue.main.async {
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
            self.callImageWebServices()
        }
    }
}

extension MasterViewController : ImageCallbackProtocol {
    func imageDataLoaded(from imageData: Data?, for id : Int) {
        guard let individualImageData = imageData else { return }
        guard let individuals = self.individuals else { return }
        var currentIndex : Int = 0
        
        for i in 0...individuals.count {
            if (individuals[i].id == id) {
                self.individuals?[i].profileImage = individualImageData
                self.individuals?[i].saveIndividualData()
                currentIndex = i
                break
            }
        }
        
        // Send a notification that the image data is loaded
        let notificationName = Notification.Name(rawValue: NOTIFICATION_LOADED_IMAGE_KEY)
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        DispatchQueue.main.async {
            let theIndexPath = IndexPath(row: currentIndex, section: 0)
            self.tableView.reloadRows(at: [theIndexPath], with: .automatic)
        }
    }
}
