//
//  HistoryObject.swift
//  Cmd-F
//
//  Created by Apple on 9/12/15.
//  Copyright (c) 2015 MHackers. All rights reserved.
//

import Foundation

class HistoryObject: NSObject, NSCoding {
    
    var historyText: String
    var historyImage: NSURL
    
    init(text: String, url: NSURL) {
        historyText = text
        historyImage = url
    }
    
    required init(coder decoder: NSCoder) {
        
        self.historyImage =  decoder.decodeObjectForKey("historyText") as! NSURL
        self.historyText = decoder.decodeObjectForKey("historyImage") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.historyText, forKey: "historyText")
        aCoder.encodeObject(self.historyImage, forKey: "historyImage")
    }
    
    
    
}
