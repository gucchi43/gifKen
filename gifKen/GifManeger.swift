//
//  GifManeger.swift
//  gifKen
//
//  Created by Hiroki Taniguchi on 2018/04/26.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import MobileCoreServices


class GifManeger: NSObject {
    
    static let shared = GifManeger()
    
    var baseImageArray:[UIImage] = [#imageLiteral(resourceName: "01"),#imageLiteral(resourceName: "02.jpg"),#imageLiteral(resourceName: "03"),#imageLiteral(resourceName: "04")]
    var imageArray:[CGImage]!
    //フレームレート
    let frameRate = CMTimeMake(1,5)
    
    func creatGif(images: [UIImage],success: @escaping (URL) -> Void, failure: @escaping (String) -> Void) {
        imageArray = []
        //適当に入れておく
        for image in images {
            if let image = image.cgImage {
                imageArray.append(image)
            }
        }
        makeGifImage({ (url) in
            print("url できたぞー", url)
            success(url)
            
        }) { (error) in
            failure(error)
        }
        
//        makeGifImage { url in  //成功した時だけ
//
//            print("url できたぞー", url)
//            return url
//
////            let animationGifView = WKWebView(frame: CGRect(x:0,y:0,width:300,height:200))
////            animationGifView.backgroundColor = UIColor.lightGray
////
////            animationGifView.load(URLRequest(url: url))
////            self.view.addSubview(animationGifView)
//        }
        
    }
    
    func makeGifImage(_ success: @escaping (URL) -> Void, failure: @escaping (String) -> Void) {
        //ループカウント　０で無限ループ
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        //フレームレート
        let frameProperties = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFDelayTime as String :CMTimeGetSeconds(frameRate)]]
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).gif")
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL,kUTTypeGIF,imageArray.count,nil)else{
            print("CGImageDestinationの作成に失敗")
            return
        }
        CGImageDestinationSetProperties(destination,fileProperties as CFDictionary?)
        
        //画像を追加
        for image in imageArray{
            CGImageDestinationAddImage(destination,image,frameProperties as CFDictionary?)
        }
        if CGImageDestinationFinalize(destination){
            //GIF生成後の処理をする
            print("成功")
            success(url)
        }else{
            print("GIF生成に失敗")
            failure("GIF生成に失敗")
        }
        
    }
    
}


