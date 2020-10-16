//
//  creature.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Creature: SKSpriteNode {
    
    var brain = NeuralNetwork(layer1: 18, layer2: 10, layer3: 5, layer4: 3)
    var energy = 1000.0
    var lastEnergy = 1000.0
    var alive = true
    var pregnant = false
    var pregnant_days = 0
    var oscilo = 0.0
    var oscilo2 = 0.0
    //diet 0=only carnivor 0,5=omnivor 1=herbivor
    var diet = CGFloat()
    var age = 0
    var eyes = [SKShapeNode]()
    var signals = [SKShapeNode]()
    var babyLayer_one_weights = [Float]()
    var babyLayer_two_weights = [Float]()
    var babyLayer_three_weights = [Float]()
    var babyDiet = CGFloat()
    var touching = false
    var contactsf = Set<Int>()
    var contactsc = Set<Int>()
    var loveHate = Float()
    var lastInputs = [Float](repeating: 0, count: 21 )
    var lastPosition = CGPoint(x: 0, y: 0)
    var sumWeights = Float()
    var weightsPanalty = Float()

    
    func addEyes(){
        let leftEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        leftEye.position = CGPoint(x: (Int(3)), y: Int(3))
        leftEye.fillColor = SKColor.white
        leftEye.lineWidth = 2.5
        leftEye.blendMode = .replace
        
        let rightEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        rightEye.position = CGPoint(x: (Int(-3)), y: Int(3))
        rightEye.fillColor = SKColor.white
        rightEye.lineWidth = 2.5
        rightEye.blendMode = .replace
        
        let middleEye = SKShapeNode(rectOf: CGSize.init(width: 2, height: 2))
        middleEye.position = CGPoint(x: (Int(0)), y: Int(6.88))
        middleEye.fillColor = SKColor.white
        middleEye.lineWidth = 2.5
        middleEye.blendMode = .replace
        
        eyes.append(leftEye)
        eyes.append(rightEye)
        eyes.append(middleEye)
        addChild(eyes[0])
        addChild(eyes[1])
        addChild(eyes[2])
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
    
    func moveCreature(shrtY: CGFloat, shrtX: CGFloat, shrtYC: CGFloat, shrtXC: CGFloat, taziskox: CGFloat, taziskoy: CGFloat, dead: inout Int, colorCR: CGFloat, colorCG: CGFloat, colorCB: CGFloat, shrtL: CGFloat, shrtR: CGFloat, shrtM: CGFloat, shrtLC: CGFloat, shrtRC: CGFloat, shrtMC: CGFloat, shrtLS: CGFloat, shrtRS: CGFloat, shrtMS: CGFloat) {
        
        var bump = 0.0
        /*if !contactsf.isEmpty {
            bump = Double(self.diet * 5)
        }
        if !contactsc.isEmpty {
            bump = Double(self.diet * 5)
        }*/
        if self.position.y == CGFloat(790) {
            bump = -5
        } else if self.position.y == CGFloat(10) {
            bump = -5
        } else if self.position.x == CGFloat(790) {
            bump = -5
        } else if self.position.x == CGFloat(10) {
            bump = -5
        }
        
        oscilo = 2 * sin(Double(age)) - 1
        oscilo2 = 2 * sin(Double(age/3)) - 1
        
        // update inputs to the neural network
        var inputs = [Float](repeating: 0, count: 18)
        if shrtLC - shrtRC > 0 {
            inputs[0] = Float(1)
        } else if shrtLC - shrtRC < 0 {
            inputs[0] = Float(-1)
        } else {inputs[0] = 0}
        if shrtL - shrtR > 0 {
            inputs[1] = Float(1)
        } else if shrtL - shrtR < 0 {
            inputs[1] = Float(-1)
        } else {inputs[1] = 0}
        inputs[2] = Float(shrtM - 0.2) * 10
        inputs[3] = Float(self.energy - self.lastEnergy) / 60
        inputs[4] = Float(shrtMC - 0.1) * 10
        if self.age < 1000 {
           inputs[5] = -1
        } else {
            inputs[5] = 1
        }
        inputs[6] = Float(self.diet) * 10 - 5
        inputs[7] = -1
        if self.energy > 1000 {
            inputs[7] = 0
        }
        if self.pregnant == true {
            inputs[7] = 1
        }
        inputs[8] = self.brain.middle_nodes[0]
        inputs[9] = self.brain.middle_nodes[1]
        inputs[10] = self.brain.middle_nodes[2]
        inputs[11] = self.brain.middle_nodes[3]
        inputs[12] = self.brain.middle_nodes[4]
        inputs[13] = self.brain.middle_nodes[5]
        inputs[14] = self.brain.middle_nodes[6]
        inputs[15] = self.brain.middle_nodes[7]
        inputs[16] = self.brain.middle_nodes[8]
        inputs[17] = self.brain.middle_nodes[9]

        //inputs[0] = Float(atan2(shrtY, shrtX) + self.zRotation - .pi/2) //* 2 / .pi))
        //inputs[1] = Float(sqrt((shrtX - self.position.x)*(shrtX - self.position.x) + (shrtY - self.position.y)*(shrtY - self.position.y))) // 1280
        //inputs[0] = Float(shrtL) * 10
        //inputs[1] = Float(shrtR) * 10
        /*inputs[0] = Float(shrtL - 0.2) * 10
        inputs[1] = Float(shrtR - 0.2) * 10
        inputs[2] = Float(shrtM - 0.2) * 10
        inputs[3] = Float(shrtLC - 0.1) * 10
        inputs[4] = Float(shrtRC - 0.1) * 10
        inputs[5] = Float(shrtMC - 0.1) * 10
        inputs[6] = Float(shrtLS - 0.1) * 10
        inputs[7] = Float(shrtRS - 0.1) * 10
        inputs[8] = Float(shrtMS - 0.1) * 10
        inputs[9] = Float(colorCR) * 330
        inputs[10] = Float(colorCG) * 330
        inputs[11] = Float(colorCB) * 330
        inputs[12] = Float(bump)
        inputs[13] = Float(self.diet) * 10 - 5
        inputs[14] = Float(self.energy/1000 - 1) * 5
        inputs[15] = Float(oscilo) * 5
        inputs[16] = Float(oscilo2) * 5
        inputs[17] = Float(self.position.distanceFromCGPoint(point: lastPosition)) * 2.3570226 - 5
        inputs[18] = lastInputs[17] - inputs[17]
        inputs[19] = self.brain.middle2_nodes[0] * 5
        inputs[20] = self.brain.middle2_nodes[1] * 5*/
        //inputs[3] = Float(shrtLC)
        //inputs[2] = Float(shrtRC)
        //inputs[4] = Float(atan2(shrtYC, shrtXC) + self.zRotation - .pi/2) // * 2 / .pi)  // * .pi / 180)
        //inputs[5] = Float(sqrt((shrtXC - self.position.x)*(shrtXC - self.position.x) + (shrtYC - self.position.y)*(shrtYC - self.position.y))) // 1280
        
        //inputs[14] = Float(oscilo)
        //inputs[9] = Float(atan2(taziskoy, taziskox) + self.zRotation - .pi/2) // * 2 / .pi)  // .pi
        //inputs[8] = Float(sqrt((taziskox - self.position.x)*(taziskox - self.position.x) + (taziskoy - self.position.y)*(taziskoy - self.position.y))) // 1280
        lastInputs = inputs

        //MAGIC HAPPENS HERE!!!
        brain.updateInputNodes(l1: &inputs)
        brain.forwardPropagate()
        self.sumWeights = 0
        for i in 0..<self.brain.layer_one_weights.count {
            self.sumWeights += abs(self.brain.layer_one_weights[i])
        }
        for i in 0..<self.brain.layer_two_weights.count {
            self.sumWeights += abs(self.brain.layer_two_weights[i])
        }
        self.weightsPanalty = self.sumWeights/Float(self.brain.layer_one_weights.count + self.brain.layer_two_weights.count)
    
        // move the thing with outputs
        let rotateLeft = SKAction.rotate(byAngle: .pi * (CGFloat(self.brain.output_nodes[0]) * 2 - 1), duration: 0.0)
        //if self.brain.output_nodes[2] > 0.5 { self.run(rotateLeft) }
        self.run(rotateLeft)
        //print(self.brain.output_nodes[0])
        //print(self.brain.output_nodes[5])
        //print(self.brain.input_nodes[11])
        //print(self.brain.input_nodes[11])
        let delta = CGVector(dx: -3 * CGFloat(self.brain.output_nodes[1]) * sin(self.zRotation), dy: 3 * CGFloat(self.brain.output_nodes[1]) * cos(self.zRotation))
        //let delta = CGVector(dx: -sin(rotate) , dy: cos(rotate))
        let moveUp = SKAction.move(by: delta, duration: 0.0 )
        //self.physicsBody?.applyImpulse(CGVector(dx: 0.002 * CGFloat(self.brain.output_nodes[2]) * -sin(self.zRotation) , dy: 0.002 * CGFloat(self.brain.output_nodes[2]) * cos(self.zRotation)))
        
        self.loveHate = (self.brain.output_nodes[2])
        /*if self.age > 1000 && self.energy > 1000 && self.loveHate > 0.5 && !self.pregnant{
            self.pregnant = true
            print("pregnant mitosis", self.name)
        }*/
        
        if self.pregnant {
            self.pregnant_days += 1
        }
        
        self.lastPosition = self.position
        //if self.brain.output_nodes[3] > 0.5 { self.run(moveUp) }
        self.run(moveUp)
        self.lastEnergy = self.energy
        self.energy -= 0.1 + Double(self.brain.output_nodes[1]) + Double(self.weightsPanalty)
        self.age += 1
        
/*
        //self.position.x = self.position.x + CGFloat((self.brain.output_nodes[0]*2-1) * self.brain.output_nodes[2]*10)
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
 */
        
        //brain.updateInputNodes(l1: &inputs)
        //self.energy = self.energy - 1
        if energy <= 0 || energy >= 10000{
            if alive {
                self.removeFromParent()
                dead += 1
                alive = false
                self.position.x = 9999.0
                self.position.y = 9999.0
            }
        }
        
        if self.diet > 0.5 {
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
        signals[2].fillColor = SKColor(red: CGFloat((self.energy ) / 1000 - 1),green: CGFloat((self.energy ) / 2000), blue: CGFloat(1 - (self.energy ) / 1000) , alpha:1.0)
        
    }
    
    func updateCreatureBrain(layer1Weights l1: [Float], layer2Weights l2: [Float], layer3Weights l3: [Float]) {
        self.brain.setLayer1Weights(l1)
        self.brain.setLayer2Weights(l2)
        self.brain.setLayer3Weights(l3)
    }
}
