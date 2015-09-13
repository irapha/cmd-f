//
//  GoogleBooksRemote.swift
//  Cmd-F
//
//  Created by Raphael Gontijo Lopes on 12/9/15.
//  Copyright (c) 2015 MHackers. All rights reserved.
//

import Foundation

class GoogleBooksRemote: NSObject {
    
    var data = NSMutableData()
    
    func connect(query:NSString) {
        print("creating request to...")
        print(query)
        let url = NSURL(string: ("https://www.googleapis.com" + (query as String)))
        let request = NSURLRequest(URL: url!)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        NSLog("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let jsonData = JSON(data: self.data)
        
        print("did finish getting data.")
        
        print(jsonData.enumerate())
        
        if let firstBookName = jsonData["items"][0]["volumeInfo"]["title"].string {
            print("First book name:")
            print(firstBookName)
        }
    }
    
    
    deinit {
      NSLog("deiniting remote.")
    }
}
