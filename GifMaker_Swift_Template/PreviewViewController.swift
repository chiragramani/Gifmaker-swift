//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 05/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    
    func addToArray(gif:Gif)
    
}

class PreviewViewController: UIViewController {
    
    
    var previewViewControllerDelegate:PreviewViewControllerDelegate?
    var gif:Gif?
    
    @IBOutlet weak var gifImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImage.image=gif?.gifImage

    }
    
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        let url: NSURL = (self.gif?.url)!
        let animatedGIF = NSData(contentsOfURL: url)!
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        navigationController?.presentViewController(activityVC, animated: true, completion: nil)
    

    }
   
    @IBAction func createAndSave(sender: AnyObject) {
        
        self.gif?.gifData=NSData(contentsOfURL: (self.gif?.url)!)
        previewViewControllerDelegate?.addToArray(gif!)
     navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
   
}
