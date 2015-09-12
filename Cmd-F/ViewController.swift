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
        print("started...")
//        let t:G8Tesseract = G8Tesseract(language:"eng")
//        t.delegate = self
//        t.image = UIImage(named: "image_sample.jpg")
//        t.recognize()
//        print(t.recognizedText)
        tesseract = G8Tesseract(language: "eng")
        tesseract!.delegate = self
        tesseract?.engineMode = .TesseractCubeCombined
        tesseract?.pageSegmentationMode = .Auto
        tesseract?.maximumRecognitionTime = 60.0
        print("ys")
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
    
    func recognizeImageText(image: UIImage) -> String {
        if let t = tesseract {
            t.image = scaleImage(image, maxDimension: 640).g8_blackAndWhite()
            t.recognize()
            return t.recognizedText
        } else {
            return ""
        }
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        if image.size.width > image.size.height {
            scaleFactor = image.size.width / image.size.height
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished")
        if tesseract != nil {
            print(recognizeImageText(image))
        }
//        tesseract.delegate = self
//
//
//        print(tesseract.recognizedText)
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

