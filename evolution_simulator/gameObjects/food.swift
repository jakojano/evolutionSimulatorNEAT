//
//  creature.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
import SpriteKit

class Food: SKShapeNode {

    var energy = 300.0
    var age = 0
    
    func moveCreature() {
        self.strokeColor = SKColor(red: 0, green: 1, blue: 0, alpha: 1)
        self.lineWidth = CGFloat(0 + energy*0.01)
        
        if self.position.x > 790 {
            //self.position.x = 790
        }
        if self.position.x < 10 {
            //self.position.x = 10
        }
        
        //self.position.y = self.position.y + CGFloat((self.brain.output_nodes[1]*2-1) * self.brain.output_nodes[2]*10)
        if self.position.y > 790 {
            //self.position.y = 790
        }
        if self.position.y < 10 {
            //self.position.y = 10
        }
        self.age += 1
    }
}
