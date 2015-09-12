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
        var url = NSURL(string: ("https://www.googleapis.com" + (query as String)))
        var request = NSURLRequest(URL: url!)
        var conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        println("didReceiveResponse")
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("here's your data:")
        println(self.data)
    }
    
    
    deinit {
        println("deiniting remote.")
    }
}
