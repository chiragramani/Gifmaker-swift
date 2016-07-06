//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 05/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

// Regift Constants
let frameCount=16
let delayTime:Float=0.2
let loopCount=0


extension UIViewController
{
    
    @IBAction func presentVideoOptions(sender:AnyObject)
    {
        if(!UIImagePickerController.isSourceTypeAvailable(.Camera))
        {
            launchVideoCameraOrPhotoLibrary(false)
        }
        else
        {
            let gifActionSheet=UIAlertController(title: "Create New Gif", message: nil, preferredStyle: .ActionSheet)
            let recordVideo=UIAlertAction(title: "Record A Video", style: .Default, handler: { (UIAlertAction) in
                
                self.launchVideoCameraOrPhotoLibrary(true)
            })
            
            let chooseFromExisting=UIAlertAction(title: "Choose From Existing", style: .Default, handler: { (UIAlertAction) in
                
                self.launchVideoCameraOrPhotoLibrary(false)
            })
            
            
            let cancelAction=UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            gifActionSheet.addAction(recordVideo)
            gifActionSheet.addAction(chooseFromExisting)
            gifActionSheet.addAction(cancelAction)
            let pinkColor=UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            gifActionSheet.view.tintColor=pinkColor
            presentViewController(gifActionSheet, animated: true, completion: nil)
        }
    }
    
    
    func launchVideoCameraOrPhotoLibrary(camera:Bool)
    {
        
        let recordVideoController=UIImagePickerController()
        recordVideoController.sourceType=camera ? UIImagePickerControllerSourceType.Camera : UIImagePickerControllerSourceType.PhotoLibrary
        recordVideoController.allowsEditing=true
        recordVideoController.mediaTypes=[kUTTypeMovie as String]
        recordVideoController.delegate=self
        
        presentViewController(recordVideoController, animated: true, completion: nil)
    }
    
    
    
}

extension UIViewController:UINavigationControllerDelegate
{
    
}

extension UIViewController:UIImagePickerControllerDelegate{
    
    func cropVideoToSquare(videoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        
        // Initialize AVAsset and AVAssetTrack
        let videoAsset = AVAsset(URL:videoURL)
        let videoTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0]
        
        // Initialize video composition and set properties
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        // Initialize instruction and set time range
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) )
        
        //Center the cropped video
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack:videoTrack)
        let firstTransform = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2.0)
        
        //Rotate 90 degrees to portrait
        let halfOfPi: CGFloat = CGFloat(M_PI_2)
        let secondTransform = CGAffineTransformRotate(firstTransform, halfOfPi);
        let finalTransform = secondTransform;
        transformer.setTransform(finalTransform, atTime:kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export the square video
        let exporter = AVAssetExportSession(asset:videoAsset, presetName:AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        let path = createPath()
        exporter.outputURL = path
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        var squareURL = NSURL()
        exporter.exportAsynchronouslyWithCompletionHandler {
            squareURL = exporter.outputURL!;
            self.convertVideoToGif(squareURL, start: start, duration: duration)
           
        }
    }
    /*
    - (NSString*)createPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
    
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    return outputURL;
    }
 */

    func createPath()->NSURL
    {
        let paths=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory=paths[0]
        let manager=NSFileManager.defaultManager()
        var outputURL=NSURL(fileURLWithPath:documentsDirectory).URLByAppendingPathComponent("output")
        do{
            try manager.createDirectoryAtURL(outputURL, withIntermediateDirectories: true, attributes: nil)
        }catch
        {
            print("Cannot create path")
        }
        outputURL=outputURL.URLByAppendingPathComponent("output.mov")
        
        do{
        try manager.removeItemAtURL(outputURL)
        }catch
        {
        print("Cannot create path")
        }
        
        return outputURL
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType=info[UIImagePickerControllerMediaType] as! String
        if(mediaType == kUTTypeMovie as String)
        {
            let mediaUrl=info[UIImagePickerControllerMediaURL] as! NSURL
            print(mediaUrl)
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(float: (end!.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }
            dismissViewControllerAnimated(true, completion: nil)
            //convertVideoToGif(mediaUrl, start: start, duration: duration)
            cropVideoToSquare(mediaUrl, start: start, duration: duration)
        }
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func convertVideoToGif(videoURL:NSURL,start:NSNumber?,duration:NSNumber?)
    {
       

        let regift: Regift
        if let start = start {
            // Trimmed
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start.floatValue, duration: duration!.floatValue, frameRate: frameCount, loopCount: loopCount)
        } else {
            // Untrimmed
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        let gifUrl=regift.createGif()
        let gif=Gif(url:gifUrl!,videoURL:videoURL,caption:nil)
        displayGif(gif)
        
    }
    
    func displayGif(gif:Gif)
    {
        dispatch_async(dispatch_get_main_queue()) {
            let gifEditorVC=self.storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditorViewController
            gifEditorVC.gif=gif
            gifEditorVC.collectionViewController=self as? SavedGifsViewController
            self.navigationController?.pushViewController(gifEditorVC, animated: true)

        }
        
        
    }
    
}

