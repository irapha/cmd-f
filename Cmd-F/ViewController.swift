//
//  ViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/11/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, G8TesseractDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.delegate = self
        tesseract.image = UIImage(named: "image_sample.jpg")
        tesseract.recognize()
        
        NSLog("%@", tesseract.recognizedText);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}

