//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Chirag Ramani on 05/07/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var gifImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let proofOfConceptGif=UIImage.gifWithName("tinaFeyHiFive")
        gifImageView.image=proofOfConceptGif
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "WelcomeViewSeen")
    }
     }
