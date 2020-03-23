//
//  StoreItem.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-15.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import Foundation
struct StoreItem: Codable, Hashable{
    var name: String
    var artist: String
    var description: String
    var kind: String
    var artworkURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind = "kind"
        case description = "description"
        case artworkURL = "artworkUrl100"
    }
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind =  try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description){
            self.description = description
        }else{
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
    static func loadItems() -> [StoreItem]? {
        guard let codedItms = try? Data(contentsOf: ArchiveURL) else {
            return nil
        }
        let propertyListdecoder = PropertyListDecoder()
        return try? propertyListdecoder.decode(Array<StoreItem>.self, from: codedItms)
        
    }
    static func saveItems(_ iTunes: [StoreItem]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedItems = try? propertyListEncoder.encode(iTunes)
        try? codedItems?.write(to: ArchiveURL, options: .noFileProtection)
    }
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("iTunes").appendingPathExtension("plist")
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
}
struct StoreItems: Codable {
    let results: [StoreItem]
}
