//
//  ViewController.swift
//  gifKen
//
//  Created by Hiroki Taniguchi on 2018/04/26.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import MobileCoreServices
import WebKit

class ViewController: UIViewController {
    
    var baseImageArray:[UIImage] = [#imageLiteral(resourceName: "01"),#imageLiteral(resourceName: "02.jpg"),#imageLiteral(resourceName: "03"),#imageLiteral(resourceName: "04")]
    var imageArray:[CGImage]!
    
    // 1秒を5分割
    let frameRate = CMTimeMake(1,5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GifManeger.shared.creatGif(images: baseImageArray, success: { (url) in
            let animationGifView = WKWebView(frame: self.view.frame)
            animationGifView.backgroundColor = UIColor.lightGray
            
            animationGifView.load(URLRequest(url: url))
            self.view.addSubview(animationGifView)
        }) { (error) in
            print(error)
        }
        imageArray = []
        
        for image in baseImageArray {
            if let image = image.cgImage {
                imageArray.append(image)
            }
        }
    }
}

