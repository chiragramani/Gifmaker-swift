//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 05/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController,UITextFieldDelegate {
    
    var gif:Gif?=nil
    
    var collectionViewController:SavedGifsViewController?
    
    
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        gifImageView.image=gif?.gifImage
         self.subscribeToKeyboardNotifications()
    }

    override func viewDidLoad() {
          super.viewDidLoad()
         captionTextField.delegate=self

       
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder=nil
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func keyboardWillShow(notification: NSNotification) {
        
       if view.frame.origin.y >= 0
       {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y<0
        {
                  view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GifEditorViewController.keyboardWillShow(_:))   , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(GifEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeFromKeyboardNotifications()
    }
    /*
    - (IBAction)presentPreview:(id)sender {
    GifPreviewViewController *previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifPreviewViewController"];
    self.gif.caption = self.captionTextField.text;
    
    Regift *regift = [[Regift alloc] initWithSourceFileURL:self.gif.videoURL destinationFileURL:nil frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    
    UIFont *captionFont = self.captionTextField.font;
    NSURL *gifURL = [regift createGifWithCaption:self.captionTextField.text font:captionFont];
    
    Gif *newGif = [[Gif alloc] initWithGifURL:gifURL videoURL:self.gif.videoURL caption:self.captionTextField.text];
    previewVC.gif = newGif;
    
    [self.navigationController pushViewController:previewVC animated:YES];
    }
 
 */
    
    @IBAction func presentPreview()
    {
    let gifPreviewVC=storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController") as! PreviewViewController
       self.gif?.caption=captionTextField.text
        
        let regift=Regift(sourceFileURL: (self.gif?.videoURL)!, destinationFileURL: nil, frameCount: 16, delayTime: 0, loopCount: 0)
        let gifURL=regift.createGif(caption: captionTextField.text, font: captionTextField.font)
        let newGif=Gif(url: gifURL!, videoURL: self.gif!.videoURL!, caption: captionTextField.text)
        gifPreviewVC.gif=newGif
        gifPreviewVC.previewViewControllerDelegate=collectionViewController
        navigationController?.pushViewController(gifPreviewVC, animated: true)
    }


   }
