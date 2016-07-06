//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 06/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var myImageVIew: UIImageView!
    var gif: Gif?
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        
        var itemsToShare = [NSData]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageVIew.image=gif?.gifImage

            }
}
