//
//  HistoryViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/13/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var historyArrayIndex: Int = 0
    var historyArray: [HistoryObject]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(HISTORY_KEY) as?[HistoryObject]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let left = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        left.direction = .Left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        right.direction = .Right
        self.view.addGestureRecognizer(right)
        
        if let array = historyArray {
            let url = array[historyArrayIndex].historyImage
            if let data = NSData(contentsOfURL: url) {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swipeLeft() {
        if let array = self.historyArray {
            if self.historyArrayIndex + 1 < array.count {
                performSegueWithIdentifier("leftSegue", sender: self)
            }
        }
        print("left")
    }
    
    func swipeRight() {
        if self.historyArrayIndex - 1 > 0 {
            performSegueWithIdentifier("leftSegue", sender: self)
        }
        print("right")
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = sender?.destinationViewController as! HistoryViewController
        if segue.identifier == "leftSegue" {
            dest.historyArrayIndex = self.historyArrayIndex + 1
        } else if segue.identifier == "rightSegue" {
            dest.historyArrayIndex = self.historyArrayIndex - 1
        }
        
    }


}
