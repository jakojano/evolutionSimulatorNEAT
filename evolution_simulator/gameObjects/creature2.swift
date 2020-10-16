//
//  creature2.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 19/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var fitness = 0
    var inputs = [Double]()
    var outputs = [Double]()
    var lifespan = 0
    var bestScore = 0
    var alive = true
    var score = 0
    var gen = 0
    var genomeInputs = 13
    var genomeOutputs = 6
    var brain = Genome(genomeInputs: 13, genomeOutputs: 7)
    
    var energy = 3000.0
    var health = 0.0
    var maxHealth = 0.0
    var fat = 1000.0
    var lastEnergy = 3000.0
    var lastHealth = 0.0
    
    var pregnant = false
    var pregnant_days = 0
    var oscilo = 0.0
    var oscilo2 = 0.0
    //diet 0=only herbivor 0,5=omnivor 1=carnivor
    var diet = CGFloat()
    var age = 0
    var eyes = [SKShapeNode]()
    var signals = [SKShapeNode]()
    var foodvectors = [SKShapeNode]()
    var babyBrain = Genome(genomeInputs: 30, genomeOutputs: 1)
    var babyDiet = CGFloat(2)
    var touching = false
    var contactsf = Set<Int>()
    var contactsc = Set<Int>()
    var loveHate = Double(0)
    var hate = Double(0)
    var love = Double(0)
    var lastInputs = [Double](repeating: 0, count: 30 )
    var lastPosition = CGPoint(x: 0, y: 0)
    var sumWeights = Double()
    var weightsPenalty = Double()
    var offset = 1.0
    var div_1 = Double(1.0)
    var div_2 = Double(2.0)
    var speedBonus = CGFloat()
    var attackBonus = Double()
    var defenseBonus = Double()
    
    func addEyes(){
        
        speedBonus = CGFloat(div_1)
        attackBonus = div_2 - div_1
        defenseBonus = 3 - div_2
        
        let leftEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        leftEye.position = CGPoint(x: (Int(-3.4641)), y: Int(-2))
        leftEye.fillColor = SKColor.white
        leftEye.lineWidth = 2
        leftEye.blendMode = .replace
        leftEye.isAntialiased = false
        
        let rightEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        rightEye.position = CGPoint(x: (Int(3.4641)), y: Int(-2))
        rightEye.fillColor = SKColor.white
        rightEye.lineWidth = 2
        rightEye.blendMode = .replace
        rightEye.isAntialiased = false
        
        let middleEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        middleEye.position = CGPoint(x: (Int(0)), y: Int(4))
        middleEye.fillColor = SKColor.white
        middleEye.lineWidth = 2
        middleEye.blendMode = .replace
        middleEye.isAntialiased = false
        
        eyes.append(leftEye)
        eyes.append(rightEye)
        eyes.append(middleEye)
        addChild(eyes[0])
        addChild(eyes[1])
        addChild(eyes[2])
        
        /*let line = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 0, y: 0))
        pathToDraw.addLine(to: CGPoint(x: 0, y: 30))
        line.path = pathToDraw
        line.lineWidth = 2
        line.strokeColor = SKColor(red: 1,green: 1, blue: 1 , alpha:1.0)
        foodvectors.append(line)
        addChild(foodvectors[0])*/
    }
    
    func addSignals(){
        let firstSignal = SKShapeNode(rectOf: CGSize.init(width: 3, height: 3))
        firstSignal.position = CGPoint(x: (Int(0)), y: Int(-6))
        firstSignal.fillColor = SKColor.green
        firstSignal.lineWidth = 0
        firstSignal.blendMode = .replace
        
        let secondSignal = SKShapeNode(rectOf: CGSize.init(width: 3, height: 3))
        secondSignal.position = CGPoint(x: (Int(0)), y: Int(-12))
        secondSignal.fillColor = SKColor.green
        secondSignal.lineWidth = 0
        secondSignal.blendMode = .replace
        
        let thirdSignal = SKShapeNode(rectOf: CGSize.init(width: 5, height: 5))
        thirdSignal.position = CGPoint(x: (Int(0)), y: Int(-18))
        thirdSignal.fillColor = SKColor.green
        thirdSignal.lineWidth = 0
        thirdSignal.blendMode = .replace
        
        let fourthSignal = SKShapeNode(rectOf: CGSize.init(width: 5, height: 5))
        fourthSignal.position = CGPoint(x: (Int(0)), y: Int(-24))
        fourthSignal.fillColor = SKColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        fourthSignal.lineWidth = 0
        fourthSignal.blendMode = .replace
        signals.append(firstSignal)
        signals.append(secondSignal)
        signals.append(thirdSignal)
        signals.append(fourthSignal)
        addChild(signals[0])
        addChild(signals[1])
        addChild(signals[2])
        addChild(signals[3])
    }
    
    func moveCreature(shrtY: CGFloat, shrtX: CGFloat, shrtYC: CGFloat, shrtXC: CGFloat, dead: inout Int, colorCR: CGFloat, colorCG: CGFloat, colorCB: CGFloat, shrtL: CGFloat, shrtR: CGFloat, shrtM: CGFloat, shrtLC: CGFloat, shrtRC: CGFloat, shrtMC: CGFloat, shrtLS: CGFloat, shrtRS: CGFloat, shrtMS: CGFloat, excessEnergy: inout Double) {
        
        if self.alive {
            //uhol a vzdialenost food
            let a = simd_float2(x: 0, y: Float(shrtM))
            let b = simd_float2(x: Float(shrtR*cos(.pi/6)), y: -1*Float(shrtR/2))
            let c = simd_float2(x: -1*Float(shrtL*cos(.pi/6)), y: -1*Float(shrtL/2))
            let d = a+b+c
            let d_length = simd_length(d)
            //let a_length = simd_length(a)
            var d_angle = Double(0.0)
            if d.x > 0 {
                d_angle = Double(acos((d.y)/(d_length))) //Double(acos((d.x*a.x+d.y*a.y)/(d_length*a_length)))
            } else if d.x < 0 {
                d_angle = Double(-1*acos((d.y)/(d_length))) //Double(-1*acos((d.x*a.x+d.y*a.y)/(d_length*a_length)))
            }
            //uhol a vzdialenost creatures
            let aC = simd_float2(x: 0, y: Float(shrtMC))
            let bC = simd_float2(x: Float(shrtRC*cos(.pi/6)), y: -1*Float(shrtRC/2))
            let cC = simd_float2(x: -1*Float(shrtLC*cos(.pi/6)), y: -1*Float(shrtLC/2))
            let dC = aC+bC+cC
            let dC_length = simd_length(dC)
            //let aC_length = simd_length(aC)
            var dC_angle = Double(0.0)
            if dC.x > 0 {
                dC_angle = Double(acos((dC.y)/(dC_length))) //Double(acos((dC.x*aC.x+dC.y*aC.y)/(dC_length*aC_length)))
            } else if dC.x < 0 {
                dC_angle = Double(-1*acos((dC.y)/(dC_length))) //Double(-1*acos((dC.x*aC.x+dC.y*aC.y)/(dC_length*aC_length)))
            }
            //uhol a vzdialenost stones
            let aS = simd_float2(x: 0, y: Float(shrtMS))
            let bS = simd_float2(x: Float(shrtRS*cos(.pi/6)), y: -1*Float(shrtRS/2))
            let cS = simd_float2(x: -1*Float(shrtLS*cos(.pi/6)), y: -1*Float(shrtLS/2))
            let dS = aS+bS+cS
            let dS_length = simd_length(dS)
            //let aC_length = simd_length(aC)
            var dS_angle = Double(0.0)
            if dS.x > 0 {
                dS_angle = Double(acos((dS.y)/(dS_length))) //Double(acos((dC.x*aC.x+dC.y*aC.y)/(dC_length*aC_length)))
            } else if dS.x < 0 {
                dS_angle = Double(-1*acos((dS.y)/(dS_length))) //Double(-1*acos((dC.x*aC.x+dC.y*aC.y)/(dC_length*aC_length)))
            }
            //nakresli vektor jedla
            /*let pathToDraw = CGMutablePath()
            pathToDraw.move(to: CGPoint(x: 0, y: 0))
            var tox = Float(0.0)
            if d.x<0 {tox = -30*pow(abs(d.x), 1/4)}else{tox = 30*pow(d.x, 1/4)}
            var toy = Float(0.0)
            if d.y<0 {toy = -30*pow(abs(d.y), 1/4)}else{toy = 30*pow(d.y, 1/4)}
            pathToDraw.addLine(to: CGPoint(x: Int(tox) , y: Int(toy)))
            foodvectors[0].path = pathToDraw*/
            
            var bump = 0.0
            if !contactsf.isEmpty {
             bump = Double(self.diet * 5)
             }
             if !contactsc.isEmpty {
             bump = Double(self.diet * 5)
             }
            /*if self.position.y == CGFloat(790) {
                bump = -5
            } else if self.position.y == CGFloat(10) {
                bump = -5
            } else if self.position.x == CGFloat(790) {
                bump = -5
            } else if self.position.x == CGFloat(10) {
                bump = -5
            }*/
            
            oscilo = 2 * sin(Double(age)) - 1
            oscilo2 = 2 * sin(Double(age/3)) - 1
            
            // update inputs to the neural network
            inputs = [Double](repeating: 0, count: 13)
            
            inputs[0] = Double(5)
            inputs[1] = Double(d_angle)
            inputs[2] = Double(dC_angle)
            inputs[3] = Double(dS_angle)
            inputs[4] = Double(d_length)*(1+2*offset)
            inputs[5] = Double(dC_length)*(1+2*offset)
            inputs[6] = Double(dS_length)*(1+2*offset)
            //inputs[7] = Double(colorCR)
            //inputs[8] = Double(colorCG)
            //inputs[9] = Double(colorCB)
            if maxHealth != 0 {
                inputs[10] = self.health/maxHealth * 10 - 5
            } else {
                inputs[10] = 1
            }
            if maxHealth != 0 {
                inputs[11] = self.fat/maxHealth
            } else {
                inputs[11] = 1
            }
            inputs[12] = Double(self.fat - self.lastHealth)
            inputs[7] = -5 + Double(self.age)*0.01
            inputs[8] = Double(self.diet) * 10 - 5
            inputs[9] = -5
            if self.pregnant == true {
                inputs[9] = 5
            }
            
            /*if age > 1000 {
             inputs[2] = 1
             } else {
             inputs[2] = -1 //Double(age/1000)
             }*/
            //inputs[11] = Double(self.position.distanceFromCGPoint(point: lastPosition)) * 2.3570226 - 5
            /*if shrtLS - shrtRS > 0 {
                inputs[6] = 5 //Double(shrtLS)
            } else if shrtLS - shrtRS < 0 {
                inputs[6] = -5 //Double(-shrtRS)
            } else {inputs[6] = 0.000001}*/
            //inputs[4] = Double(shrtL/(-shrtR+1))
            //inputs[5] = Double(shrtLC/(-shrtRC+1))
            //inputs[6] = Double(shrtLS/(-shrtRS+1))
            //inputs[7] = Double(shrtM)
            //inputs[8] = Double(shrtMC)
            /*if (shrtLS + shrtRS)/2 > shrtMS {
                inputs[9] = 5
            } else if (shrtLS + shrtRS)/2 < shrtMS {
                inputs[9] = -5
            } else {inputs[9] = 0.000001}*/
            //inputs[9] = Double(shrtMS)
            //inputs[12] = Double(bump)
            //self.eyes[0].strokeColor = SKColor.init(red: shrtL, green: shrtLC, blue: shrtLS, alpha: 1)
            //self.eyes[1].strokeColor = SKColor.init(red: shrtR, green: shrtRC, blue: shrtRS, alpha: 1)
            //self.eyes[2].strokeColor = SKColor.init(red: shrtM, green: shrtMC, blue: shrtMS, alpha: 1)
            /*inputs[16] = Double(oscilo2) * 5
             inputs[17] = Double(self.position.distanceFromCGPoint(point: lastPosition)) * 2.3570226 - 5
             if shrtLC - shrtRC > 0 {
             inputs[0] = Double(1)
             } else if shrtLC - shrtRC < 0 {
             inputs[0] = Double(-1)
             } else {inputs[0] = 0}
             if shrtL - shrtR > 0 {
             inputs[1] = Double(1)
             } else if shrtL - shrtR < 0 {
             inputs[1] = Double(-1)
             } else {inputs[1] = 0}
             inputs[2] = Double(shrtM - 0.2) * 10
             inputs[3] = Double(self.energy - self.lastEnergy) / 60
             inputs[4] = Double(shrtMC - 0.1) * 10
             if self.age < 1000 {
             inputs[5] = -1
             } else {
             inputs[5] = 1
             }
             inputs[6] = Double(self.diet) * 10 - 5
             inputs[7] = -1
             if self.energy > 1000 {
             inputs[7] = 0
             }
             if self.pregnant == true {
             inputs[7] = 1
             }*/
            
            lastInputs = inputs

            //MAGIC HAPPENS HERE!!!
            self.lastHealth = self.fat
            self.outputs = self.brain.forwardPropagate(inputs: inputs)
            //print(outputs)
            self.offset = self.outputs[6]*10
            self.sumWeights = 0
            for i in 0..<self.brain.connections.count {
                if self.brain.connections[i].enabled{
                    self.sumWeights += abs(self.brain.connections[i].weight)
                }
            }
            self.weightsPenalty = self.sumWeights/Double(self.brain.connections.count)
            
            //print(self.outputs)
            // move the thing with outputs
            //let rotateLeft = SKAction.rotate(byAngle: .pi/4 * (CGFloat(self.outputs[0]) * 2 - 1), duration: 1.0)
            let rotateLeft = SKAction.rotate(byAngle: .pi/4 * (CGFloat(self.outputs[0]-0.5) * 2), duration: 1/60)
            let rotateRight = SKAction.rotate(byAngle: -.pi/4 * (CGFloat(self.outputs[1]-0.5) * 2), duration: 1/60)
            if self.outputs[0]>0.5 {self.run(rotateLeft)}
            if self.outputs[1]>0.5 {self.run(rotateRight)}
            
            var forward = CGFloat(0.0)
            if self.outputs[0]>0.5 && self.outputs[1]>0.5 {
                if self.outputs[0]>self.outputs[1] {
                    forward = CGFloat((self.outputs[1]-0.5)*2)
                }
                if self.outputs[0]<self.outputs[1] {
                    forward = CGFloat((self.outputs[0]-0.5)*2)
                }
                if self.outputs[0]==self.outputs[1] {
                    forward = CGFloat((self.outputs[1]-0.5)*2)
                }
            }
            speedBonus = CGFloat(div_1)
            let delta = CGVector(dx: -CGFloat(3+speedBonus) * (CGFloat(self.outputs[5]) * 2 - 1) * sin(self.zRotation), dy: CGFloat(3+speedBonus) * (CGFloat(self.outputs[5]) * 2 - 1) * cos(self.zRotation))
            //let delta = CGVector(dx: -1 * forward /* * (CGFloat(self.outputs[2]) * 2 - 1)*/ * sin(self.zRotation), dy: 1 * forward /* * (CGFloat(self.outputs[2]) * 2 - 1)*/ * cos(self.zRotation))
            let moveUp = SKAction.move(by: delta, duration: 1/60 )
            
            self.loveHate = (self.outputs[3])
            if self.outputs[2]>0.5 {self.love = (self.outputs[2])} else {self.love = 0.0}
            if self.outputs[3]>0.5 {self.hate = (self.outputs[3])} else {self.hate = 0.0}
            if self.hate>0.5 && self.love<0.5 {self.texture = SKTexture(imageNamed: "Hate") }
            if self.hate>0.5 && self.love>0.5 {self.texture = SKTexture(imageNamed: "LoveHate") }
            if self.hate<0.5 && self.love>0.5 {self.texture = SKTexture(imageNamed: "Love") }
            //liečenie
            if self.outputs[4]>0.5 && self.health < self.maxHealth && self.age > 1000 && self.fat > 0.0 {
                if self.fat >= self.outputs[4]-0.5 {
                    self.fat -= self.outputs[4]-0.5
                    self.health += self.outputs[4]-0.5
                } else {
                    self.fat -= self.fat
                    self.health += self.fat
                }
            }
            /*if self.age > 1000 && self.health+self.fat > 1000 && self.love > 0.5 && !self.pregnant{
                self.pregnant = true
                print("pregnant mitosis", self.name)
            }*/

            if self.pregnant {
                self.pregnant_days += 1
            }
            
            self.lastPosition = self.position
            //if self.outputs[0]>0.5 && self.outputs[1]>0.5 {
            if self.outputs[5] > 0.6 || self.outputs[5] < 0.4 {
                self.run(moveUp)
            }
                //self.physicsBody?.applyImpulse(CGVector(dx: -0.02 * CGFloat(3+speedBonus) * (CGFloat(self.outputs[5]) * 2 - 1) * sin(self.zRotation) , dy: 0.02 * CGFloat(3+speedBonus) * (CGFloat(self.outputs[5]) * 2 - 1) * cos(self.zRotation)))
            //}
            //self.lastEnergy = self.energy
            
            //if !abs(0.2*(Double(self.outputs[0]))).isNaN {self.energy -= abs(0.3*(Double(self.outputs[0])))}
            //if !abs(0.2*(Double(self.outputs[1]))).isNaN {self.energy -= abs(0.2*(Double(self.outputs[1])))}
            //if !abs(0.2*(Double(self.outputs[2]))).isNaN {self.energy -= abs(0.2*(Double(self.outputs[2])))}
            //if !abs(0.1*weightsPenalty).isNaN {self.energy -= abs(0.1*weightsPenalty)}
            //self.energy -= 1
            
            if !abs(0.2*(Double(self.outputs[0]))).isNaN {
                self.fat -= abs(0.2*(Double(self.outputs[0])))
                excessEnergy += abs(0.2*(Double(self.outputs[0])))
            }
            if !abs(0.2*(Double(self.outputs[1]))).isNaN {
                self.fat -= abs(0.2*(Double(self.outputs[1])))
                excessEnergy += abs(0.2*(Double(self.outputs[1])))
            }
            if !abs(0.2*(Double(self.outputs[2]))).isNaN {
                self.fat -= abs(0.2*(Double(self.outputs[2])))
                excessEnergy += abs(0.2*(Double(self.outputs[2])))
            }
            if !abs(0.2*(Double(self.outputs[3]))).isNaN {
                self.fat -= abs(0.2*(Double(self.outputs[3])))
                excessEnergy += abs(0.2*(Double(self.outputs[3])))
            }
            if !abs(0.2*(Double(self.outputs[5]))).isNaN {
                self.fat -= abs(0.2*(Double(self.outputs[5])))
                excessEnergy += abs(0.2*(Double(self.outputs[5])))
            }
            /*if !abs(0.1*weightsPenalty).isNaN {
                self.fat -= abs(0.1*weightsPenalty)
                excessEnergy += abs(0.1*weightsPenalty)
            }*/
            //metabolizmus
            self.fat -= 1
            excessEnergy += 1
            //podvyziva
            if self.fat < 0 {
                self.health -= abs(self.fat)
                self.fat = 0
            }
            //obezita
            if self.fat > self.maxHealth && self.age > 1000 {
                let weightPenalty = abs(maxHealth - self.fat)
                self.health -= weightPenalty/2
                excessEnergy += weightPenalty/2
            }
            
            self.age += 1
            
            /*if energy <= 0 || energy >= 4000{
             if alive {
             dead += 1
             alive = false
             self.texture = SKTexture(imageNamed: "Dead")
             //self.removeFromParent()
             //self.position.x = 9999.0
             //self.position.y = 9999.0
             }
             }*/
            //print(self.fat)
            //print(self.health)
            //print(self.maxHealth)
            
            self.size = CGSize(width: CGFloat(4 + self.fat*0.004),height: CGFloat(4 + self.health*0.004))
            
            if self.health < 0 {
                if alive {
                    dead += 1
                    alive = false
                    self.texture = SKTexture(imageNamed: "Dead")
                    excessEnergy += abs(self.health)
                    excessEnergy += abs(self.fat)
                    self.health = 0
                }
            }
            //coloring signals
            /*if self.diet > 0.5 {
             signals[0].fillColor = SKColor.green
             } else {
             signals[0].fillColor = SKColor.red
             }
             if self.loveHate > 0.5 + 1/6 {
             signals[1].fillColor = SKColor(red: 1, green: 0, blue: 0.4 , alpha:1.0)
             } else if self.loveHate < 0.5 - 1/6 {
             signals[1].fillColor = SKColor.orange
             } else {
             signals[1].fillColor = SKColor.lightGray
             }
             signals[2].fillColor = SKColor(red: CGFloat((self.energy ) / 1000 - 1),green: CGFloat((self.energy ) / 2000), blue: CGFloat(1 - (self.energy ) / 1000) , alpha:1.0)*/
        }
    }
    
    func updateCreatureBrain(brain: Genome) {
        self.brain = brain
    }
    
    func crossover(parent2:Player)->Player {
        let child = Player()
        child.brain = self.brain.crossover(parent2: parent2.brain)
        return child
    }
    
    func calculateFitness() {
        self.fitness = self.age
    }

}
