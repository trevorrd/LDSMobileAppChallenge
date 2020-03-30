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
    
    var detailViewController: DetailViewController? = nil
    //var managedObjectContext: NSManagedObjectContext? = nil
    var individuals : [Individual]?
    
    let INDIVIDUAL_IMAGE_LOADED_NOTIFICATION = Notification.Name(rawValue: NOTIFICATION_LOADED_IMAGE_KEY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        navigationItem.leftBarButtonItem = editButtonItem
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        callWebService()
    }
    
    // MARK: - Helper Methods
    
    func callWebService() {
        //let individualsDictionary : [ String : [Individual] ]
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
    
    // MARK: - Table
    
//    @objc
//    func insertNewObject(_ sender: Any) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let newEvent = Event(context: context)
//
//        // If appropriate, configure the new managed object.
//        newEvent.timestamp = Date()
//
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                guard let individuals = individuals else { return }
                controller.individual = individuals[indexPath.row]
                //controller.detailItem = object
                //controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = fetchedResultsController.managedObjectContext
//            context.delete(fetchedResultsController.object(at: indexPath))
//
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
//    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
//        cell.textLabel!.text = event.timestamp!.description
//    }
//
//    // MARK: - Fetched results controller
//
//    var fetchedResultsController: NSFetchedResultsController<Event> {
//        if _fetchedResultsController != nil {
//            return _fetchedResultsController!
//        }
//
//        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//
//        // Set the batch size to a suitable number.
//        fetchRequest.fetchBatchSize = 20
//
//        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
//        aFetchedResultsController.delegate = self
//        _fetchedResultsController = aFetchedResultsController
//
//        do {
//            try _fetchedResultsController!.performFetch()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//
//        return _fetchedResultsController!
//    }
//    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete:
//            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        default:
//            return
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
//        case .move:
//            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        default:
//            return
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
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
