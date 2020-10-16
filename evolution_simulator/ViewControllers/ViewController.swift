//
//  ViewController.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import CoreAudioKit

class ViewController: NSViewController {
    
    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupPrefs()
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                //scene.scaleMode = .aspectFill

                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
        }
    }
}

extension ViewController {
    
    // MARK: - Preferences
    
    func setupPrefs() {
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.removeObserver(notificationName)
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) {
            (notification) in self.updateFromPrefs()
        }
    }
    
    func updateFromPrefs() {
        
        if let gameScene = skView.scene as? GameScene {
            let notificationName = Notification.Name(rawValue: "PrefsChanged")
            NotificationCenter.default.removeObserver(self)
            print("preferences changed to: ", gameScene.prefs.population, gameScene.prefs.foods, gameScene.prefs.stones )
            gameScene.population = gameScene.prefs.population
            gameScene.lunch = gameScene.prefs.foods
            gameScene.soil = gameScene.prefs.stones
            gameScene.restart(nextGeneration: [], new: true)
        }
        
    }
}

