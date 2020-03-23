//
//  URL+Helpers.swift
//  Sayeh_iTunes_iOSII_Final
//
//  Created by Sayeh Heshmati Mafi on 2020-02-15.
//  Copyright © 2020 Sayeh Heshmati Mafi. All rights reserved.
//

import Foundation
extension URL {
    // Query dictionary for URLComponents
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1)}
        
        return components?.url
    }
    
    // Convert Http to Https
    func withHTTPS() -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        return components?.url
    }
}
