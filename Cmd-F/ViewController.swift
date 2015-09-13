//
//  ViewController.swift
//  Cmd-F
//
//  Created by Spruce Bondera on 9/11/15.
//  Copyright © 2015 MHackers. All rights reserved.
//

import UIKit

let HISTORY_KEY = "history key"
class ViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var textQuery: UISearchBar!
    
    var tesseract: G8Tesseract?
    var picker: UIImagePickerController?
    
    @IBOutlet var cameraButton: UIButton!
    @IBAction func cameraButtonAction(sender: UIButton) {
        picker?.takePicture()
    }
    
    func swipeDown() {
        performSegueWithIdentifier("historySegue", sender: self)
        print("test")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: "presentCamera")
        self.view.addGestureRecognizer(tap)
        print("init")
        
        // Intialize tesseract.
        tesseract = G8Tesseract(language:"eng")
        tesseract!.delegate = self

        // Swipe up on imageview loads the camera view.
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeUp:")
        swipeUp.direction = .Up
        self.view.addGestureRecognizer(swipeUp)
        
        // Initialize progress animation.
        createScannerAnimation()
    }
    
    func respondToSwipeUp(gesture: UIGestureRecognizer) {
        if picker != nil {
            presentViewController(picker!, animated: true, completion: nil)
        } else {
            print("fail")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        picker = createCamera()
        print("view loaded")
    }
    
    func initializeOverlay(picker: UIImagePickerController) {
        NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
        let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        overlayView.addGestureRecognizer(tap)
        let swipe = UISwipeGestureRecognizer(target: self, action: "swipeDown")
        swipe.direction = .Down
        overlayView.addGestureRecognizer(swipe)
        cameraButton.layer.cornerRadius = cameraButton.bounds.size.width / 2
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
            
            let screenSize = UIScreen.mainScreen().bounds.size
            let cameraAspectRatio = 4.0 / 3.0
            let imageWidth = floor(Double(screenSize.width) * cameraAspectRatio)
            let scale = CGFloat(ceil((Double(screenSize.height) / imageWidth) * 10.0) / 10.0)
            let translationX = CGFloat(0.0)
            let translationY = CGFloat(1 * textQuery.bounds.height)
            
            picker.cameraViewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale)
                , CGAffineTransformMakeTranslation(translationX, translationY))
            
            return picker
        } else {
            return nil
        }
    }
    

    
    func highlight(selectedChar: CGRect){
        //Draw low-opacity yellow rectangle over character
        
        var highlightedSpace: CGRect
        
        highlightedSpace.origin = selectedChar.origin
        
        highlightedSpace.height == selectedChar.height
        highlightedSpace.width == selectedChar.width * 2
        
        var context: CGContextRef
        context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 0.5)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor!)
        
        
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
    func saveDataToDisk(image: UIImage) -> NSURL? {
        let manager = NSFileManager.defaultManager()
        
        let documents = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!, isDirectory: true)
        let images = documents.URLByAppendingPathComponent("Images", isDirectory: true)
        if manager.fileExistsAtPath(images.filePathURL!.absoluteString) {
            let name = NSProcessInfo().globallyUniqueString + ".png"
            let imageUrl = images.URLByAppendingPathComponent(name, isDirectory: false)
            UIImagePNGRepresentation(image)?.writeToURL(imageUrl, atomically: true)
            return imageUrl
        } else {
            return nil
        }
    }
    
    // DONE modify to save query and image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // Do anything that requires the captured image here
        print("Starting tesseract")
        
        // Find ranges in recognizedText where seachQuery matches. Remove all new lines and spaces from both strings (so that the blocks array correspond one-to-one).
        var searchQuery = textQuery.text
        
        // Start spinner.
        self.spinner.hidden = false
        self.spinner.startAnimating()
        
        // Display image.
        imageView.image = image
        
        print("animate")
        // Start loading animation.
        animationView.startAnimating()
        
        print("dismiss")
        dismissViewControllerAnimated(true, completion: {() -> () in
            // Stop spinner
            self.spinner.stopAnimating()
            self.spinner.hidden = true
            
            // Start character recognition.
            self.tesseract(searchQuery, image: image)
        })
        
        var imageNSURL = saveDataToDisk(image)
        var NewHistoryObject: HistoryObject
        if imageNSURL != nil && searchQuery != nil {
            NewHistoryObject = HistoryObject(text: searchQuery!, url: imageNSURL!)
            let defaults = NSUserDefaults.standardUserDefaults()
            var historyArray = defaults.objectForKey(HISTORY_KEY) as? [HistoryObject]
            if historyArray == nil {
                let arr = [NewHistoryObject]
                defaults.setObject(arr, forKey: HISTORY_KEY)
            }
            else {
                historyArray!.append(NewHistoryObject)
                defaults.setObject(historyArray, forKey: HISTORY_KEY)
            }
            defaults.synchronize()
        }
    }
    
    func errorAlert(title: String, message: String) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func tesseract(searchQuery: String, image: UIImage!) {
        print("Starting tesseract")
        
        // Give tesseract a preprocessed UIImage.
        tesseract!.image = image.g8_grayScale().g8_blackAndWhite()
        
        print("Running OCR")
        // Recognize characters.
        tesseract!.recognize()
        let recognizedText = tesseract!.recognizedText
        let formattedRecognizedText = recognizedText.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
        let strippedSearchQuery = searchQuery.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
        let formattedSearchQuery = strippedSearchQuery
        // Get match start and end index.
        if strippedSearchQuery.characters.count > 0 {
            if let rangeOfMatch = formattedRecognizedText.rangeOfString(formattedSearchQuery) {
                let matchStartIndex = formattedRecognizedText.startIndex.distanceTo(rangeOfMatch.startIndex)
                let matchEndIndex = formattedRecognizedText.startIndex.distanceTo(rangeOfMatch.endIndex)
                var blocks = tesseract!.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol) as! [G8RecognizedBlock]
                // Only use blocks that match searchQuery.
                let filteredBlocks = Array(blocks[matchStartIndex..<matchEndIndex])
                
                // Make tesseract display the image with the highlighted blocks.
                imageView.image = tesseract!.imageWithBlocks(filteredBlocks, drawText: true, thresholded: false)
                
                // Request information from google books.
                //            let remote = GoogleBooksRemote()
                //            let query = ("/books/v1/volumes?q=" + recognizedText!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
                //            NSLog("%@", query)
                //            remote.connect(query)
                animationView.stopAnimating()
            } else {
                errorAlert("Unknown query", message: "Could not be completed")
            }
            }
        } else {
            errorAlert("Unknown query", message: "Could not be completed")
        }
    }
    
    func createScannerAnimation() {
        print("starting animation")
        
        var animationImages: [UIImage] = []
        
        for i in 1..<122 {
            var imgName: String
            
            if i < 10 {
                imgName = "animation/scanner_img_sequence/frame-00000" + String(i) + ".png"
            } else if i < 100 {
                imgName = "animation/scanner_img_sequence/frame-0000" + String(i) + ".png"
            } else {
                imgName = "animation/scanner_img_sequence/frame-000" + String(i) + ".png"
            }
            
            let frame = UIImage(named: imgName)!
            animationImages.append(frame)
        }
        
        animationView.animationImages = animationImages
        animationView.animationDuration = 3
        animationView.animationRepeatCount = 0
    }
}

