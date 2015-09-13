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
    var isFirstTime = true
    var swipeGesture: UISwipeGestureRecognizer?
    var swipeUp: UISwipeGestureRecognizer?
    
    
    @IBOutlet var cameraButton: UIButton!
    @IBAction func cameraButtonAction(sender: UIButton) {
        // Start spinner.
        self.spinner.hidden = false
        self.spinner.startAnimating()
        
        picker?.takePicture()
    }
    
    var historyArrayIndex: Int?
    var indexDelta = 0
    var historyArray: [HistoryObject]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(HISTORY_KEY) as? [HistoryObject]
    }
    
 
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let tap = UITapGestureRecognizer(target: self, action: "presentCamera")
//        self.view.addGestureRecognizer(tap)
        
        print("init")
        
        // Intialize tesseract.
        tesseract = G8Tesseract(language:"eng")
        tesseract!.delegate = self

        
        
        // Swipe up on imageview loads the camera view.
        
        let left = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        left.direction = .Left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        right.direction = .Right
        self.view.addGestureRecognizer(right)
        let up = UISwipeGestureRecognizer(target: self, action: "upSwipe")
        up.direction = .Up
        self.view.addGestureRecognizer(up)
        if let array = historyArray, let index = historyArrayIndex {
            let url = array[index].historyImage
            if let data = NSData(contentsOfURL: url) {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }
        // Initialize progress animation.
        createScannerAnimation()
    }
    
    func swipeLeft() {
        if let array = self.historyArray, let index = self.historyArrayIndex {
            if index + 1 < array.count {
                indexDelta = 1
                performSegueWithIdentifier("selfSegue", sender: self)
            }
        }
        print("left")
    }
    
    func swipeRight() {
        if let index = self.historyArrayIndex {
            if index - 1 > 0 {
                indexDelta = -1
                performSegueWithIdentifier("selfSegue", sender: self)
            }
        }
        print("right")
    }
    
    func upSwipe() {
        presentCamera()
    }
    
    func swipeDownCamera() {
        dismissViewControllerAnimated(true, completion: nil)
        historyArrayIndex = -1
        swipeLeft()
    }
    
    override func viewDidAppear(animated: Bool) {
        picker = createCamera()
        if isFirstTime {
            isFirstTime = false
            presentCamera()
        }
        print("view loaded")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = sender?.destinationViewController as? HistoryViewController {
            if let index = historyArrayIndex {
                dest.historyArrayIndex = index + indexDelta
            }
        } else {
            print("wrong view type")
        }
    }
    
    func initializeOverlay(picker: UIImagePickerController) {
        NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
        let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        overlayView.addGestureRecognizer(tap)
        let downGesture = UISwipeGestureRecognizer(target: self, action: "swipeDownCamera")
        downGesture.direction = .Down
        overlayView.addGestureRecognizer(downGesture)
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
            let translationY = CGFloat(textQuery.bounds.height)
            
            picker.cameraViewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale)
                , CGAffineTransformMakeTranslation(translationX, translationY))
            
            return picker
        } else {
            return nil
        }
    }
    

    
    func getRect(selectedChar: CGRect){
        //Draw low-opacity yellow rectangle over character
        
        let highlightedSpace = CGRect(x: selectedChar.origin.x, y: selectedChar.origin.y, width: selectedChar.width * 2, height: selectedChar.height)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 0.5)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, highlightedSpace)
    }
    
    func presentCamera() {
        // Stop spinner
        self.spinner.stopAnimating()
        self.spinner.hidden = true
        
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
        print("starting data writing attempt...")
        let manager = NSFileManager.defaultManager()
        
        let documents = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!, isDirectory: true)
        let images = documents.URLByAppendingPathComponent("Images", isDirectory: true)
        print(images)
        if manager.fileExistsAtPath(images.filePathURL!.absoluteString) {
            let name = NSProcessInfo().globallyUniqueString + ".png"
            let imageUrl = images.URLByAppendingPathComponent(name, isDirectory: false)
            if let png = UIImagePNGRepresentation(image) {
                png.writeToURL(imageUrl, atomically: true)
            } else {
                print("png creation failed")
            }
            
            print("data writing worked")
            return imageUrl
        } else {
            print("data writing failed")
            return nil
        }
    }
    
    // DONE modify to save query and image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // Do anything that requires the captured image here
        print("Starting tesseract")
        
        // Find ranges in recognizedText where seachQuery matches. Remove all new lines and spaces from both strings (so that the blocks array correspond one-to-one).
        var searchQuery = textQuery.text
        
        // Display image.
        imageView.image = image
        
        print("animate")
        // Start loading animation.
        animationView.startAnimating()
        
        print("dismiss")
        dismissViewControllerAnimated(true, completion: {() -> () in
            // Start character recognition.
            if searchQuery != nil {
                self.tesseract(searchQuery!, image: image)
            }
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
                historyArray = [NewHistoryObject] + historyArray!
                defaults.setObject(historyArray, forKey: HISTORY_KEY)
            }
            defaults.synchronize()
            historyArrayIndex = 0
        }
        if let obj = NSUserDefaults.standardUserDefaults().objectForKey(HISTORY_KEY) as? [HistoryObject] {
            print("NSUserDefaults suceeded")
            print(obj.count)
        } else {
            print("NSUserDefaults never written")
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

        // Stop spinner
        self.spinner.stopAnimating()
        self.spinner.hidden = true
        
        // Give tesseract a preprocessed UIImage.
        tesseract!.image = image.g8_grayScale().g8_blackAndWhite()
        
        print("Running OCR")
        // Recognize characters.
        tesseract!.recognize()
        let recognizedText = tesseract!.recognizedText
        
        let formattedRecognizedText = recognizedText.lowercaseString.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let strippedSearchQuery = searchQuery.lowercaseString.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
        let formattedSearchQuery = strippedSearchQuery
        
        var blocks = tesseract!.recognizedBlocksByIteratorLevel(G8PageIteratorLevel.Symbol) as! [G8RecognizedBlock]
        
        // Create new recoText from blocks characters.
        var recoText = ""
        for block in blocks {
            recoText += block.text.lowercaseString
        }
        
        // Get match start and end index.
        if strippedSearchQuery.characters.count > 0 {
            print(recoText)
            print("\n\n")
            print(formattedSearchQuery)
            if let rangeOfMatch = recoText.rangeOfString(formattedSearchQuery) {
                let matchStartIndex = recoText.startIndex.distanceTo(rangeOfMatch.startIndex)
                let matchEndIndex = recoText.startIndex.distanceTo(rangeOfMatch.endIndex)
                
                // Only use blocks that match searchQuery.
                let filteredBlocks = Array(blocks[matchStartIndex..<matchEndIndex])
                // Make tesseract display the image with the highlighted blocks.
//                imageView.image = tesseract!.imageWithBlocks(filteredBlocks, drawText: false, thresholded: false)
                
                UIGraphicsBeginImageContextWithOptions(tesseract!.image.size, false, tesseract!.image.scale)
                let context = UIGraphicsGetCurrentContext()
                UIGraphicsPushContext(context!)
                tesseract!.image.drawInRect(CGRect(origin: CGPointZero, size: tesseract!.image.size))
                
                CGContextSetLineWidth(context, 10.0)
                CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor)
                
                // draw all rectangles.
                for block in filteredBlocks {
                    let boundBox = block.boundingBoxAtImageOfSize(tesseract!.image.size)
                    let rekt = CGRectMake(boundBox.origin.x, boundBox.origin.y, boundBox.size.width, boundBox.size.height)
                    
                    CGContextStrokeRect(context, rekt)
                    
                }
                
                UIGraphicsPopContext()
                let highlightedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                imageView.image = highlightedImage
                
                animationView.stopAnimating()
            } else {
                animationView.stopAnimating()
            }
            
            // Request information from google books.
            let remote = GoogleBooksRemote()
            let query = ("/books/v1/volumes?q=" + recognizedText!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&key=AIzaSyDhY74nCaymN5Slm-doWyoweJrAbLYWJVM")
            remote.connect(query)
            
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
        
        animationView.transform = CGAffineTransformMakeScale(CGFloat(1), CGFloat(1.2))
    }
}

