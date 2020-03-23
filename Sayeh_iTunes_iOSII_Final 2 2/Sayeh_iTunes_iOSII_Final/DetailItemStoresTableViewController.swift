//
//  DetailItemStoresTableViewController.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-17.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class DetailItemStoresTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate  {

    @IBOutlet weak var segmentButton: UISegmentedControl!
    @IBOutlet weak var descriptionTextDetail: UITextView!
    @IBOutlet weak var artistDetailLabel: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleDetailLabel: UILabel!
    var category = ""
    var item: StoreItem?
    var image: UIImage!
    var favoriteItem: StoreItem?
    
    
    @IBAction func segmentButtonTapped(_ sender: UISegmentedControl) {
        if segmentButton.selectedSegmentIndex == 0 {
           ShareButtonTapped(segmentButton)
        }
        if segmentButton.selectedSegmentIndex == 1 {
         emailButtonTapped(segmentButton)
        }
        
        
    }
    @IBAction func AddFavoriteTapped(_ sender: UIBarButtonItem) {
        favoriteItem = item
        let beforen = favoritItemSet.count
        favoritItemSet.insert(favoriteItem!)
        let aftern = favoritItemSet.count
        if beforen != aftern {
            favoritItemArray.append(favoriteItem!)
        }
        
        switch category {
        case "movie": //"movie", "music", "software", "ebook"
            favoriteMovie.append(favoriteItem!)
            favoriteMovie.removeDuplicates()
            favDict.updateValue(favoriteMovie, forKey: "movie")
        case "music":
            favoriteMusic.append(favoriteItem!)
            favoriteMusic.removeDuplicates()
            favDict.updateValue(favoriteMusic, forKey: "music")
        case "software":
            favoriteSoftware.append(favoriteItem!)
            favoriteSoftware.removeDuplicates()
            favDict.updateValue(favoriteSoftware, forKey: "software")
        case "ebook":
            favoriteBooks.append(favoriteItem!)
            favoriteBooks.removeDuplicates()
            favDict.updateValue(favoriteBooks, forKey: "ebook")
        default:
            return
        }
        
       
      
        print("-------favorite \(String(describing: favoriteItem))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let item = item{
            titleDetailLabel.text = item.name
            artistDetailLabel.text = item.artist
            descriptionTextDetail.text = item.description
            imageDetail.image = image
            print(item)
        }
    }

func ShareButtonTapped(_ sender: UISegmentedControl) {
    
    guard let image = imageDetail.image else { return }
    let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    activityController.popoverPresentationController?.sourceView = sender
    present(activityController,animated: true, completion: nil)
}
func emailButtonTapped(_ sender: UISegmentedControl) {
      guard MFMailComposeViewController.canSendMail() else {
          return
      }
      
      let mailComposer = MFMailComposeViewController()
      mailComposer.mailComposeDelegate = self
      mailComposer.setToRecipients(["sayehmafi@gmail.com"])
      mailComposer.setSubject("Testing from the app")
      mailComposer.setMessageBody("Hi, Testing from the app.", isHTML: true)
      
      present(mailComposer, animated: true, completion: nil)
      
      func mailComposeController(_ controller:
          MFMailComposeViewController, didFinishWith result:
          MFMailComposeResult, error: Error?) {
          dismiss(animated: true, completion: nil)
      }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               imageDetail.image =  selectedImage
               dismiss(animated: true, completion: nil)
               
           }
       }
}

}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
