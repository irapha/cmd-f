//
//  HistoryObject.swift
//  Cmd-F
//
//  Created by Apple on 9/12/15.
//  Copyright (c) 2015 MHackers. All rights reserved.
//

import Foundation

class HistoryObject {
    
    let historyCellText: String
    let historyCellImage: NSURL
    
    init(text: String, imageURL: NSURL){
        historyCellText = text
        historyCellImage = imageURL
        
    }
    
    
}