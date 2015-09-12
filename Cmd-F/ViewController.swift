//
//  ViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/11/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var tesseract : G8Tesseract = G8Tesseract(language:"eng")
        tesseract.delegate = self
        tesseract.image = UIImage(named: "image_sample_2.jpeg")?.g8_blackAndWhite().g8_grayScale()
        tesseract.recognize()
        
        mainImageView.image = tesseract.image
        NSLog("%@", tesseract.recognizedText)
    }
    
    override func viewDidAppear(animated: Bool) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            print("Woo")
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            picker.showsCameraControls = false
            picker.navigationBarHidden = true
            picker.toolbarHidden = true
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
}

