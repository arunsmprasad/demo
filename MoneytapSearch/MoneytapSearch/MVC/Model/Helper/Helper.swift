//
//  Helper.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    //MARK - View
    func roundCorner(for view: UIView, radius: Float, borderColor color: UIColor) {
       
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
        view.clipsToBounds = true
    }
    
    func getServiceUrl(aString: String) -> String {
        
        return "\(API_SERVICE_URL)\(aString)&\(API_LIST_LIMIT)" // form the url string with the given search string
    }
    
    func getWikipediaLinkForSearch(aSearch: String) -> String {
        
        return "https://en.wikipedia.org/wiki/\(aSearch.replacingOccurrences(of: " ", with: "_"))"
    }
    
    func postNotificationForViewController(viewcontroller: UIViewController, name: String ) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func addSpaceToLabel(aText: String, space: Int) -> String {
        
        var aSaceString = ""
        aSaceString = String(repeating: " ", count: space)
        return "\(aSaceString)\(aText)"
    }
}
