//
//  ViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/11/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var overlayView: UIView!
    
    var tesseract: G8Tesseract?
    var picker: UIImagePickerController?
    
    @IBOutlet var cameraButton: UIButton!
    @IBAction func cameraButtonAction(sender: UIButton) {
        picker?.takePicture()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let gesture = UITapGestureRecognizer(target: self, action: "presentCamera")
        self.view.addGestureRecognizer(gesture)
        print("init")
        
        // Intialize tesseract.
        tesseract = G8Tesseract(language:"eng")
        tesseract!.delegate = self
        
        // Give tesseract a preprocessed UIImage.
//        tesseract!.image = UIImage(named: "image_sample.jpg")?.g8_grayScale().g8_blackAndWhite()
        
        // Recognize cahracters.
//        tesseract!.recognize()
//        let recognizedText = tesseract!.recognizedText

//        print(recognizedText)
        
        // Find ranges in recognizedText where seachQuery matches. Remove all new lines and spaces from both strings (so that the blocks array correspond one-to-one).
//        let searchQuery = "museum loaned furniture";
        
//        let rangeOfMatch = recognizedText.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "").rangeOfString(searchQuery.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: ""))
        
        // Get match start and end index.
//        let matchStartIndex = recognizedText.startIndex.distanceTo(rangeOfMatch!.startIndex)
//        let matchEndIndex = recognizedText.startIndex.distanceTo(rangeOfMatch!.endIndex)
        
        // Get each character's block
//        var blocks = tesseract!.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol) as! [G8RecognizedBlock]
        // Only use blocks that match searchQuery.
//        let filteredBlocks = Array(blocks[matchStartIndex..<matchEndIndex])

         // Make tesseract display the image with the highlighted blocks.
//         imageView.image = tesseract!.imageWithBlocks(filteredBlocks, drawText: true, thresholded: false)
        
        // How to request information from google books.
//        let remote = GoogleBooksRemote()
//        let query = ("/books/v1/volumes?q=" + recognizedText!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
//        NSLog("%@", query)
//        remote.connect(query)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        picker = createCamera()
        print("view loaded")
    }
    
    func initializeOverlay(picker: UIImagePickerController) {
        NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
        let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        overlayView.addGestureRecognizer(tap)
        cameraButton.layer.cornerRadius = 0.2 * cameraButton.bounds.size.width
        cameraButton.backgroundColor = UIColor.whiteColor()
        
        overlayView.frame = picker.cameraOverlayView!.frame
        overlayView.opaque = false
        overlayView.backgroundColor = UIColor.clearColor()

    }
    
    func createCamera() -> UIImagePickerController? {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            print("Woo")
            picker.delegate = self as protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            picker.showsCameraControls = false
            picker.navigationBarHidden = true
            picker.toolbarHidden = true
            initializeOverlay(picker)
            picker.cameraOverlayView = overlayView
            return picker
        } else {
            return nil
        }
    }
    
    func presentCamera() {
        print("tapp")
        if picker != nil {
            presentViewController(picker!, animated: true, completion: nil)

        } else {
            print("fail")
        }
    }
    
    func closeKeyboard() {
        print("tap recognized!")
        overlayView.endEditing(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            print("finished")
//            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
    }
        
}

