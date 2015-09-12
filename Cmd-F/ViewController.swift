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
    
    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet var overlayView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var tesseract : G8Tesseract = G8Tesseract(language:"eng")
        tesseract.delegate = self
        tesseract.image = UIImage(named: "image_sample.jpg")?.g8_blackAndWhite().g8_grayScale()
        tesseract.recognize()
        
        mainImageView.image = tesseract.image
        NSLog("%@", tesseract.recognizedText)
        
        NSLog("Making simple request")
        
        let remote = GoogleBooksRemote()
        remote.connect("/books/v1/volumes?q=flowers&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
        
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

