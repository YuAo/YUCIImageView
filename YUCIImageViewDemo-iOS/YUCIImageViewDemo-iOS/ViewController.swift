//
//  ViewController.swift
//  YUCIImageViewDemo-iOS
//
//  Created by YuAo on 2/26/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

import UIKit
import YUCIImageView

class ViewController: UIViewController {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

