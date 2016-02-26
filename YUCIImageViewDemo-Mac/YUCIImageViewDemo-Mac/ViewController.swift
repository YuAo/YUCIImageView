//
//  ViewController.swift
//  YUCIImageViewDemo-Mac
//
//  Created by YuAo on 2/25/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

import Cocoa
import YUCIImageView
import CoreImage

class ViewController: NSViewController {

    @IBOutlet weak var imageView: YUCIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.renderer = YUCIImageRenderingSuggestedRenderer()
        
        let checkboardGenerator = CIFilter(name: "CICheckerboardGenerator")!
        checkboardGenerator.setDefaults()
        let outputImage = checkboardGenerator.outputImage!.imageByCroppingToRect(CGRectMake(0, 0, 400, 400))
        self.imageView.imageContentMode = YUCIImageViewContentMode.Center
        self.imageView.image = outputImage
    }

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }
    
}

