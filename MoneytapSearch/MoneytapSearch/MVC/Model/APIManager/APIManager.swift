//
//  APIManager.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import SystemConfiguration

class ApiManager {
    
    func isNetworkReachable() -> Bool {
        
        var aAddress = sockaddr_in()
        aAddress.sin_len = UInt8(MemoryLayout.size(ofValue: aAddress))
        aAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &aAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func callSearchService(searchString: String, completionBlock: @escaping ([SearchList]) -> Void) {
        
        //Implementing URLSession
        let urlString = HELPER.getServiceUrl(aString: searchString)
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "")) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            let aJsonObject = JSON.init(data: data)
            
            let aJson = aJsonObject["query"]["pages"]
            print(aJson)
            if aJson != .null {
                let aArray = aJson.arrayObject
                let aPagesArray = aArray as! [[String: Any]]
                
                var aListArray = [SearchList]()
                
                if aPagesArray.count != 0 {
                    
                    for aDict in aPagesArray {
                        
                        let aTitle = aDict[TITLE] as? String
                        var aDetail = ""
                        var aImageUrl = ""
                        
                        if aDict[TERMS] != nil {
                            
                            let aDetailDict = aDict[TERMS] as! [String: Any]
                            if aDetailDict.count != 0 {
                                
                                aDetail = ((aDetailDict[DETAILS] as? [String])?.first)!
                            }
                        }
                        if aDict[THUMBNAIL] != nil {
                            
                            let aImageDict = aDict[THUMBNAIL] as! [String: Any]
                            if aImageDict.count != 0 {
                                
                                aImageUrl = (aImageDict[IMAGE_URL] as? String)!
                            }
                        }
                        let aSearchList = SearchList.init(message: aTitle, details: aDetail, imageUrl: aImageUrl)
                        aListArray.append(aSearchList)
                    }
                }
                // Adding particulr values in an array as SearchList modelo
                completionBlock(aListArray)
            }
            }.resume()
    }
}
