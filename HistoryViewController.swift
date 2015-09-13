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
    var historyArrayIndex: Int?
    var historyArray: [HistoryObject]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(HISTORY_KEY) as?[HistoryObject]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let array = historyArray {
            print("NSUserDefaults worked!")
            print("length \(array.count)")
        } else {
            print("NSUserDefaults failed")
        }
        
        let left = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        left.direction = .Left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        right.direction = .Right
        self.view.addGestureRecognizer(right)
        let back = UISwipeGestureRecognizer(target: self, action: "backSwipe")
        back.direction = .Up
        self.view.addGestureRecognizer(back)
        
        if let array = historyArray, let index = historyArrayIndex {
            let url = array[index].historyImage
            if let data = NSData(contentsOfURL: url) {
                let image = UIImage(data: data)
                imageView.image = image
            }
        
        
        // Do any additional setup after loading the view.
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if historyArrayIndex == nil {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swipeLeft() {
        if let array = self.historyArray, let index = self.historyArrayIndex {
            if index + 1 < array.count {
                performSegueWithIdentifier("leftSegue", sender: self)
            }
        }
        print("left")
    }
    
    func swipeRight() {
        if let index = self.historyArrayIndex {
            if index - 1 > 0 {
                performSegueWithIdentifier("leftSegue", sender: self)
            }
        }
        print("right")
    }
    
    func backSwipe() {
        performSegueWithIdentifier("backSwipe", sender: self)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = sender?.destinationViewController as? HistoryViewController {
            if let index = historyArrayIndex {
                if segue.identifier == "leftSegue" {
                    dest.historyArrayIndex = index + 1
                } else if segue.identifier == "rightSegue" {
                    dest.historyArrayIndex = index - 1
                }
            }
        }
    }


}
