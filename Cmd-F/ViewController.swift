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
        tesseract = G8Tesseract(language:"eng")
        tesseract!.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: "presentCamera")
        self.view.addGestureRecognizer(gesture)
        print("init")
        // Get each character's block
        // let blocks = tesseract.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol)
        // TODO: Filter blocks array to only include the blocks that match the search.
        // Make tesseract display the image with the highlighted blocks.
        // imageView.image = tesseract.imageWithBlocks(blocks, drawText: true, thresholded: true)
        
        // NSLog("%@", tesseract.recognizedText)
        
        // How to request information from google books.
        // let remote = GoogleBooksRemote()
        // remote.connect("/books/v1/volumes?q=flowers&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
        
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

