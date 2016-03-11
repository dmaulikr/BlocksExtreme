//
//  MainViewController.swift
//  BlockExtreme
//
//  Created by Jason Chan MBP on 3/9/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
