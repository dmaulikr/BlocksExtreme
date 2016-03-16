//
//  GameViewController.swift
//  BlockExtreme
//
//  Created by Jason Chan MBP on 2/24/16.
//  Copyright (c) 2016 Jason Chan. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var swiftris:Swiftris!
    var backgroundMusic : AVAudioPlayer?
    
        var seconds = 0
        var timer:NSTimer?
    
    var panPointReference:CGPoint?
    
    var timedState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let backgroundMusic = self.setupAudioPlayerWithFile("theme", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        backgroundMusic?.play()
        
        // Present the scene.
        skView.presentScene(scene)
        
        
        
    }
    
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
//    @IBAction func pauseButton(sender: AnyObject) {
//    
//        pauseGame()
//        timer?.invalidate()
//    
//    }
    @IBAction func timerButton(sender: UIButton) {
        print("timer button tapped")
        
    }
    
    @IBAction func backButton(sender: UIButton) {
        timer?.invalidate()
        swiftris.endGame()
        backgroundMusic?.stop()
        pauseGame()
        self.dismissViewControllerAnimated(true, completion: nil)
            
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
        
    }
    
    func pauseGame()
    {
        scene.view!.paused = true
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        
        swiftris.rotateShape()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            // #3
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
        
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        
        swiftris.dropShape()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // #6
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
        self.scene.movePreviewShape(fallingShape) {
            // #16
            self.view.userInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    //timer function
    
    
        func timerOn() {
    
            seconds = 20
    
            if (timer == nil) {
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)}
        }
    
    //countdown method
    
        func subtractTime() {
            seconds--
            timerLabel.text = "\(seconds)"
            print(seconds)
    
            if(seconds == 0)  {

                swiftris.endGame()
                timer?.invalidate()
              self.dismissViewControllerAnimated(true, completion: nil)
    
    
    
            }
        }
    
    func gameDidBegin(swiftris: Swiftris) {
        
        if timedState == true {
            timerOn() }
        
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        timerLabel.text = "\(seconds)"
    
        
        scene.tickLengthMillis = TickLengthLevelOne
        
        
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
        
        scene.playSound("gameover.mp3")
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: Array<Array<Block>>()) {
            swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound("levelup.mp3")
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound("drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        self.view.userInteractionEnabled = false
        // #10
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #11
                self.gameShapeDidLand(swiftris)
            }
            scene.playSound("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    // #17
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
}
