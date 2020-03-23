//
//  FavoriteTableViewController.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-23.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    @IBOutlet weak var segmentButton: UISegmentedControl!
    
    var selectedCategoryArr = [StoreItem]()
    
    var localfmo = favoriteMovie
    var localmu = favoriteMusic
    var localboo = favoriteBooks
    var localapps = favoriteSoftware
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategoryArr = favoritItemArray
        
        tableView.reloadData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(editButtonTapped))
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        StoreItem.saveItems(selectedCategoryArr)
    }
    
    @IBAction func swgmentButtonTapped(_ sender: UISegmentedControl) {
        
        switch segmentButton.selectedSegmentIndex {
        case 0:
            selectedCategoryArr.removeAll()
            selectedCategoryArr = favoriteMovie
            tableView.reloadData()
        case 1:
            selectedCategoryArr.removeAll()
            selectedCategoryArr = favoriteMusic
            tableView.reloadData()
        case 2:
            selectedCategoryArr.removeAll()
            selectedCategoryArr = favoriteSoftware
            tableView.reloadData()
        case 3:
            selectedCategoryArr.removeAll()
            selectedCategoryArr = favoriteBooks
            tableView.reloadData()
        case 4:
            selectedCategoryArr.removeAll()
            selectedCategoryArr = favoritItemArray
            tableView.reloadData()
        default:
            selectedCategoryArr = favoritItemArray
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedCategoryArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCellIdentifier", for: indexPath)
        
        // configure(cell: cell, forItemAt: indexPath)
        cell.textLabel?.text = selectedCategoryArr[indexPath.row].name
        cell.detailTextLabel?.text = selectedCategoryArr[indexPath.row].artist
        let url = selectedCategoryArr[indexPath.row].artworkURL
        
        let task = URLSession.shared.dataTask(with: url){(data,response,error) in
            guard let imageData = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                cell.imageView?.image = image
            }
        }
        task.resume()
        return cell
    }
    
    //--------------------------------------------- Table View Extra Functionality
    //Move selected row
    override func tableView(_ tableView: UITableView,
                            moveRowAt fromIndexPath: IndexPath,
                            to: IndexPath) {
        
        // 1- Remove cell from old place
        let movedObj = selectedCategoryArr.remove(at: fromIndexPath.row)
        // 2- Insert cell to new place
        selectedCategoryArr.insert(movedObj, at: to.row)
        
    }
    // MARK: Action Methods-----------------------------------------------------------------
    //MARK: - Edit button
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
    }
    //custom editing style defult delete
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            switch segmentButton.selectedSegmentIndex {
            case 0:
                selectedCategoryArr.remove(at: indexPath.row)
                favoriteMovie.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case 1:
                selectedCategoryArr.remove(at: indexPath.row)
                favoriteMusic.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            case 2:
                selectedCategoryArr.remove(at: indexPath.row)
                favoriteSoftware.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            case 3:
                selectedCategoryArr.remove(at: indexPath.row)
                favoriteBooks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            case 4:
                selectedCategoryArr.remove(at: indexPath.row)
                favoritItemArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            default:
                selectedCategoryArr = favoritItemArray
            }
        }
    }
}

//MARK: - extentions




