//
//  ViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/11/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var tesseract: G8Tesseract?
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Intialize tesseract.
//        let tesseract = G8Tesseract(language:"eng")
//        tesseract.delegate = self
        
        // Give tesseract a preprocessed UIImage.
//        tesseract.image = UIImage(named: "image_sample.jpg")?.g8_grayScale().g8_blackAndWhite()
        
        // Recognize cahracters.
//        tesseract.recognize()
//        let recognizedText = tesseract.recognizedText

//        print(recognizedText)
        
        // Find ranges in recognizedText where seachQuery matches. Remove all new lines and spaces from both strings (so that the blocks array correspond one-to-one).
//        let searchQuery = "museum loaned furniture";
        
//        let rangeOfMatch = recognizedText.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "").rangeOfString(searchQuery.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: ""))
        
        // Get match start and end index.
//        let matchStartIndex = recognizedText.startIndex.distanceTo(rangeOfMatch!.startIndex)
//        let matchEndIndex = recognizedText.startIndex.distanceTo(rangeOfMatch!.endIndex)
        
        // Get each character's block
//        var blocks = tesseract.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol) as! [G8RecognizedBlock]
        // Only use blocks that match searchQuery.
//        let filteredBlocks = Array(blocks[matchStartIndex..<matchEndIndex])

         // Make tesseract display the image with the highlighted blocks.
//         imageView.image = tesseract.imageWithBlocks(filteredBlocks, drawText: true, thresholded: false)
        
        // How to request information from google books.
//        let remote = GoogleBooksRemote()
//        let query = ("/books/v1/volumes?q=" + recognizedText!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
//        NSLog("%@", query)
//        remote.connect(query)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        cameraCreation()
        print("view loaded")
    }
    
    func closeKeyboard() {
        print("tap recognized!")
        overlayView.endEditing(false)
        
    }

    func cameraCreation() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            print("Woo")
            picker.delegate = self as! protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            picker.showsCameraControls = false
            picker.navigationBarHidden = true
            picker.toolbarHidden = true
            NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
            let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
            overlayView.addGestureRecognizer(tap)
            overlayView.frame = picker.cameraOverlayView!.frame
            overlayView.opaque = false
            overlayView.backgroundColor = UIColor.clearColor()
            picker.cameraOverlayView = overlayView
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        } else {
            print("doesn't exist")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished")
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

