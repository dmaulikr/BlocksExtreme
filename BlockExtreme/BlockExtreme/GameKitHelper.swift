import UIKit
import Foundation
import GameKit

let PresentAuthenticationViewController =
"PresentAuthenticationViewController"

class GameKitHelper: NSObject {
    static let sharedInstance = GameKitHelper()
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    
    
    func authenticateLocalPlayer() {
    
    let localPlayer = GKLocalPlayer()
    localPlayer.authenticateHandler = {(viewController, error) in
    if viewController != nil {
    
    self.authenticationViewController = viewController
    NSNotificationCenter.defaultCenter().postNotificationName(
    PresentAuthenticationViewController, object: self)
} else if error == nil {
    
    self.gameCenterEnabled = true
    }
    } }
}