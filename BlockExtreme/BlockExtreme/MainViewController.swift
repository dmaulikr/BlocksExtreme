//
//  MainViewController.swift
//  BlockExtreme
//
//  Created by Jason Chan MBP on 3/9/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import GameKit


class MainViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    @IBAction func achievButton(sender: UIButton) {
        
        showLeader()
    }
    @IBAction func leaderBoardButton(sender: UIButton) {
    
        showLeader()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        authenticateLocalPlayer()
        
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if ((viewController) != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }else{
                print("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "timedGame") {
            
            if let GVC: GameViewController = segue.destinationViewController as? GameViewController {
                GVC.timedState = true }
            
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //Mark: - Leaderboard functions
    
 
  
    
    //shows leaderboard screen
    func showLeader() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
