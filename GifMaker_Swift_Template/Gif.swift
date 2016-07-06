//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 06/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif:NSObject,NSCoding
{

    var url:NSURL?
    var caption:String?
    var gifImage:UIImage?
    var videoURL:NSURL?
    var gifData:NSData?
    
  
    
    init(url:NSURL,videoURL:NSURL,caption:String?)
    {
    self.url=url
    self.caption=caption
    self.videoURL=videoURL
    self.gifImage = UIImage.gifWithURL(url.absoluteString)!
    self.gifData = nil
    }
    
    init(name:String)
    {
    self.gifImage = UIImage.gifWithName(name)
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.url=aDecoder.decodeObjectForKey("gifURL") as? NSURL
        self.caption=aDecoder.decodeObjectForKey("caption") as? String
        self.videoURL=aDecoder.decodeObjectForKey("videoURL") as? NSURL
        self.gifData = aDecoder.decodeObjectForKey("gifData") as? NSData
        self.gifImage=aDecoder.decodeObjectForKey("gifImage") as? UIImage
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.url, forKey: "gifURL")
        aCoder.encodeObject(self.caption, forKey: "caption")
        aCoder.encodeObject(self.videoURL, forKey: "videoURL")
        aCoder.encodeObject(self.gifImage, forKey: "gifImage")
        aCoder.encodeObject(self.gifData, forKey: "gifData")

        
        
    }
    
}
