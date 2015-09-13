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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var textQuery: UISearchBar!
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        picker = createCamera()
        print("view loaded")
    }
    
    func initializeOverlay(picker: UIImagePickerController) {
        NSBundle.mainBundle().loadNibNamed("OverlayView", owner: self, options: nil)
        let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        overlayView.addGestureRecognizer(tap)
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
            let translationY = CGFloat(2 * textQuery.bounds.height)
            
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("Starting tesseract")
    
        // Find ranges in recognizedText where seachQuery matches. Remove all new lines and spaces from both strings (so that the blocks array correspond one-to-one).
        var searchQuery: String
        
        if let query = textQuery.text {
            searchQuery = query
        } else {
            searchQuery = ""
        }
        var imageNSURL = saveDataToDisk(image)
        var NewHistoryObject: HistoryObject
        if imageNSURL != nil {
            NewHistoryObject = HistoryObject(text: searchQuery, url: imageNSURL!)
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
        
        dismissViewControllerAnimated(true, completion: {() -> () in
            self.tesseract(searchQuery, image: image)
        })
    }

    func tesseract(searchQuery: String, image: UIImage!) {
        print("Starting tesseract")

        // Give tesseract a preprocessed UIImage.
        tesseract!.image = image.g8_grayScale().g8_blackAndWhite()
        
        // Recognize characters.
        tesseract!.recognize()
        let recognizedText = tesseract!.recognizedText
        
        if searchQuery.characters.count > 0 {
            // TODO: allow recognition of multiple matches.
            let formattedRecognizedText = recognizedText.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
            let formattedSearchQuery = searchQuery.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "")
            
            // Get match start and end index.
            let rangeOfMatch = formattedRecognizedText.rangeOfString(formattedSearchQuery)
            let matchStartIndex = formattedRecognizedText.startIndex.distanceTo(rangeOfMatch!.startIndex)
            let matchEndIndex = formattedRecognizedText.startIndex.distanceTo(rangeOfMatch!.endIndex)
            
            // Get all recognized character's block
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
        } else {
            // TODO: display a 'warning: no query performed' message.
        }
    }
}

