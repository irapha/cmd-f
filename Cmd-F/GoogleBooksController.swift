//
//  GoogleBooksController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/13/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class GoogleBooksController: UIViewController {

    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var navBarImage: UIImageView!
    var historyArrayIndex: Int?
    
    override func viewDidLoad() {
        let html = NSBundle.mainBundle().URLForResource("GooglePreviewPage", withExtension: "hmtl")
        let request = NSURLRequest(URL: html)
        self.webView.loadRequest(request)
    }
}
