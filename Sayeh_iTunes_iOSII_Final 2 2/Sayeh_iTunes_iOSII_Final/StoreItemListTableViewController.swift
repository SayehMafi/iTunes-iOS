//
//  StoreItemListTableViewController.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-15.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import UIKit

class StoreItemListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items = [StoreItem]()
    let queryOptions = ["movie", "music", "software", "ebook"]
    let webServiceJSONDecoder = WebServiceJSONDecoder()
    var category = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           fetchMatchingitems()
         searchBar.resignFirstResponder()
       }
    func fetchMatchingitems() {
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        category = mediaType
        
        if !searchTerm.isEmpty {
            let query = [ "term": searchTerm,
                          "lang": "en_us",
                          "media": mediaType]
            webServiceJSONDecoder.fetchItem(matching: query, completion: {
                (items) in
                DispatchQueue.main.async {
                    if let items = items{
                        self.items = items
                        self.tableView.reloadData()
                    }else{
                        print("Unable to load data.")
                    }
                }
            })
        }
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath){
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.artist
        cell.imageView?.image = #imageLiteral(resourceName: "gray.png")
        
        let task = URLSession.shared.dataTask(with: item.artworkURL){(data,response,error) in
            
            guard let imageData = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                cell.imageView?.image = image
            }
        }
        task.resume()
    }
    
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        fetchMatchingitems()
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        // cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    //MARK: - table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Check if EditEmoji segue is running pass the model object
        // related to selected cell
        if segue.identifier == "DetailCell"{
            
            // Which cell is selected ........................
            let indexPath = tableView.indexPathForSelectedRow!
            let item = items[indexPath.row]
            //................................................
            
            // Create a reference to next VC which is the first VC of UINavigationController
//            let navVC = segue.destination as! UINavigationController
            let detailTableViewController = segue.destination as! DetailItemStoresTableViewController
            //................................................
            
            // Pass selected Object to target VC
            detailTableViewController.item =  item
            detailTableViewController.category = category
            if let cell = tableView.cellForRow(at: indexPath){
                detailTableViewController.image =  cell.imageView?.image
            }
        }
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//              NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
//              perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
//          }
//
//    @objc func reload(_ searchBar: UISearchBar) {
//              guard let queryy = searchBar.text, queryy.trimmingCharacters(in: .whitespaces) != "" else {
//                  print("nothing to search")
//                  return
//              }
//              print(queryy)
//          }
}


