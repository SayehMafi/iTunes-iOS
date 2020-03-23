//
//  WebServiceJSONDecoder.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-15.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import Foundation
// 1- Connect to Web Service
// 2- Get the data and decode it from JSON to PhotoInfo.self object
struct WebServiceJSONDecoder {
    func fetchItem(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        let baseURL = URL(string: "https://itunes.apple.com/search?")!
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries. ")
            return
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let storeItems = try? decoder.decode(StoreItems.self, from: data){
                completion(storeItems.results)
            }else{
                print ("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
                
            }
        }
        task.resume()
    }
}
