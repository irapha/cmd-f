//
//  HistoryObject.swift
//  Cmd-F
//
//  Created by Apple on 9/12/15.
//  Copyright (c) 2015 MHackers. All rights reserved.
//

import Foundation

class HistoryObject: NSObject, NSCoding {
    
    var historyCellText: String
    var historyCellImage: NSURL
    
    required init(coder decoder: NSCoder) {
        
        self.historyCellImage =  decoder.decodeObjectForKey("historyCellText") as! NSURL
        self.historyCellText = decoder.decodeObjectForKey("historyCellImage") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.historyCellText, forKey: "historyCellText")
        aCoder.encodeObject(self.historyCellImage, forKey: "historyCellImage")
    }
    
}
