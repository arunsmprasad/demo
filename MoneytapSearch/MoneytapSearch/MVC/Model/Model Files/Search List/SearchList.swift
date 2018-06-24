//
//  SearchList.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation

class SearchList {
    
    var title: String?
    var details: String?
    var imageUrl: String?

    
    init(message: String?, details: String?, imageUrl: String?) {
        
        self.title = message
        self.details = details
        self.imageUrl = imageUrl
    }
}
