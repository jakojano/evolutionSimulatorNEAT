//
//  Stone.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 30/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
import SpriteKit

class Stone: SKShapeNode {

    var energy = 0
    
        func moveCreature() {
            if self.position.x > 790 {
                self.position.x = 790
            }
            if self.position.x < 10 {
                self.position.x = 10
            }
            
            //self.position.y = self.position.y + CGFloat((self.brain.output_nodes[1]*2-1) * self.brain.output_nodes[2]*10)
            if self.position.y > 790 {
                self.position.y = 790
            }
            if self.position.y < 10 {
                self.position.y = 10
            }
        }
    }
