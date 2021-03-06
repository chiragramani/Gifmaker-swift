//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 06/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,PreviewViewControllerDelegate {

    var gifs=[Gif]()
    
    @IBOutlet weak var fullStackView: UIStackView!
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.stringByAppendingString("/savedGifs")
        return gifsPath
    }
    
    
    let cellMargin:CGFloat=12.0
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        myCollectionView.reloadData()
     // self.gifs = NSKeyedUnarchiver.unarchiveObjectWithFile(gifsFilePath) as! [Gif]
        if gifs.count==0
        {
        fullStackView.hidden=false
        }
        else
        {
        fullStackView.hidden=true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        showWelcome()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionViewCell=myCollectionView.dequeueReusableCellWithReuseIdentifier("CellId", forIndexPath: indexPath) as! CollectionViewCell
        
        collectionViewCell.imageView.image=gifs[indexPath.row].gifImage
        
        return collectionViewCell
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width=(collectionView.frame.size.width-cellMargin*2.0)/2.0
    let size=CGSizeMake(width, width)
        return size
    }
    
    func addToArray(gif:Gif)
    {
    print("Mission exceeded")
    gifs.append(gif)
    NSKeyedArchiver.archiveRootObject(gifs, toFile: gifsFilePath)
    
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedGif=gifs[indexPath.row]
        let detailVC=storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.gif=selectedGif
        detailVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(detailVC, animated: true, completion: nil)
        
        
    }
   
    func showWelcome()->Void
    {
    if (!NSUserDefaults.standardUserDefaults().boolForKey("WelcomeViewSeen"))
    {
        let welcomeVC=storyboard?.instantiateViewControllerWithIdentifier("WelcomeViewController")
        self.navigationController?.pushViewController(welcomeVC!, animated: true)
        }
        else
    {
        self.gifs = NSKeyedUnarchiver.unarchiveObjectWithFile(gifsFilePath) as! [Gif]
        }
    
    }
    

}
