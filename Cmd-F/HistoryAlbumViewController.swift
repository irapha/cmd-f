//
//  HistoryAlbumViewController.swift
//  Cmd-F
//
//  Created by Apple on 9/12/15.
//  Copyright (c) 2015 MHackers. All rights reserved.
//

import Foundation
import UIKit



class HistoryAlbumViewController: UIViewController{

    @IBOutlet var scrollView: UIScrollView!
    
    
    var images: [UIImage] = []
    var frame: CGRect = CGRectMake(0, 0, 0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in (0..<images.count) {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = images[index]
            self.scrollView .addSubview(subView)
        
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(images.count), height: self.scrollView.frame.size.height)
    }
}
