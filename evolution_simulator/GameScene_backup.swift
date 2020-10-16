//
//  GameScene.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

/*import SpriteKit
import GameplayKit

extension CGPoint {
    func distanceFromCGPoint(point:CGPoint)->CGFloat{
        return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
    }
}

struct ColliderType {
    static let Creature:UInt32 = 1
    static let Food:UInt32 = 2
    static let Stone:UInt32 = 3
}

let degreesToRadians = CGFloat.pi / 180
let radiansToDegrees = 180 / CGFloat.pi

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var population = 19
    var lunch = 39
    var soil = 2
    var creatures = [Creature]()
    var creaturesDiet0 = [Int]()
    var creaturesDiet1 = [Int]()
    var lefteyes = [SKShapeNode]()
    var righteyes = [SKShapeNode]()
    var stones = [Stone]()
    var remove = [Int]()
    var babies = [Creature]()
    var foods = [Food]()
    var distances = [CGFloat]()
    var mindist = Int()
    var shrtX = [CGFloat]()
    var shrtY = [CGFloat]()
    var shrtL = [CGFloat]()
    var shrtR = [CGFloat]()
    var distancesC = [CGFloat]()
    var mindistC = Int()
    var shrtXC = [CGFloat]()
    var shrtYC = [CGFloat]()
    var shrtLC = [CGFloat]()
    var shrtRC = [CGFloat]()
    var distancesS = [CGFloat]()
    var mindistS = Int()
    var shrtLS = [CGFloat]()
    var shrtRS = [CGFloat]()
    var colorCR = [CGFloat]()
    var colorCG = [CGFloat]()
    var colorCB = [CGFloat]()
    var dead = 0
    var bestLayer_one_weights = [Float]()
    var bestLayer_two_weights = [Float]()
    var bestLayer_one_weights0 = [Float]()
    var bestLayer_two_weights0 = [Float]()
    var bestLayer_one_weights1 = [Float]()
    var bestLayer_two_weights1 = [Float]()
    var best_diet = CGFloat()
    var generation = 1
    var gentext = String()
    let GenerationLabel = SKLabelNode(text: "Generation" )
    var taziskox = [CGFloat]()
    var taziskoy = [CGFloat]()
    var tazx = CGFloat()
    var tazy = CGFloat()
    var maxuhol = 0.0
    var tracers = [SKShapeNode]()
    var tracerColorR = CGFloat()
    var tracerColorG = CGFloat()
    var tracerColorB = CGFloat()
    
    override func didMove(to view: SKView) {
        
        //tracer heatmapy
        for i in 0...79{
            for j in 0...79{
                let tracer = SKShapeNode(rectOf: CGSize.init(width: 10, height: 10))
                tracer.position = CGPoint(x: 10 * i, y: 10 * j)
                tracer.fillColor = SKColor.white
                tracer.lineWidth = 0
                tracer.blendMode = .replace
                tracers.append(tracer)
            }
        }
        for i in 0...tracers.count - 1 {
            addChild(tracers[i])
        }
        
        gentext = String(generation)
        GenerationLabel.position.x = 480
        GenerationLabel.position.y = 640
        GenerationLabel.text = "Generation" + gentext
        addChild(GenerationLabel)
        
        self.physicsWorld.contactDelegate = self
        
        for _ in 0...1000 {
            shrtX.append(1)
            shrtY.append(1)
            shrtL.append(1)
            shrtR.append(1)
            shrtXC.append(1)
            shrtYC.append(1)
            shrtLC.append(1)
            shrtRC.append(1)
            shrtLS.append(1)
            shrtRS.append(1)
            colorCR.append(1)
            colorCG.append(1)
            colorCB.append(1)
            taziskox.append(0)
            taziskoy.append(0)
        }
        
        for _ in 0...lunch {
            distances.append(9999)
        }
        
        for _ in 0...1000 {
            distancesC.append(9999)
            distancesS.append(9999)
        }
        
        for number in 0...lunch {
            foods.append(addFood())
            addChild(foods[number])
        }
        
        for number in 0...soil {
            stones.append(addStones())
            addChild(stones[number])
        }
        
        for number in 0...(population + 1)/2 - 1 {
            if (bestLayer_one_weights.isEmpty && bestLayer_two_weights.isEmpty) {
                creatures.append(addCreature(Diet:0.0))
            } else {
                creatures.append(addCreatureWithWeights(Layer1Weights: bestLayer_one_weights, Layer2Weights: bestLayer_two_weights, Diet: 0.0))
            }
            creatures[number].name = "Creature" + String(number)
            addChild(creatures[number])
        }
        for number in (population + 1)/2...(population + 1)/2 + (population + 1)/2 - 1 {
            if (bestLayer_one_weights.isEmpty && bestLayer_two_weights.isEmpty) {
                creatures.append(addCreature(Diet:1.0))
            } else {
                creatures.append(addCreatureWithWeights(Layer1Weights: bestLayer_one_weights, Layer2Weights: bestLayer_two_weights, Diet: 1.0))
            }
            creatures[number].name = "Creature" + String(number)
            addChild(creatures[number])
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for i in 0...creatures.count - 1 {
            if creatures[i].alive == false {
                remove.append(i)
            }
        }
        if remove.isEmpty == false {
            for i in (0...remove.count - 1).reversed() {
                creatures.remove(at: remove[i])
            }
        }
        remove.removeAll()
        
        creaturesDiet0.removeAll()
        creaturesDiet1.removeAll()
        if creatures.isEmpty{
            //just do nothing special
        } else {
        for i in 0...creatures.count - 1 {
            if creatures[i].diet == 0.0 {
                creaturesDiet0.append(i)
            } else {
                creaturesDiet1.append(i)
            }
        }
        }
        
        if creaturesDiet0.count == 1 {
            print("LAST DIET 0 ONE")
            if creatures[creaturesDiet0[0]].alive == true {
                bestLayer_one_weights0 = creatures[creaturesDiet0[0]].brain.layer_one_weights
                bestLayer_two_weights0 = creatures[creaturesDiet0[0]].brain.layer_two_weights
                best_diet = creatures[creaturesDiet0[0]].diet
            }
        }
        
        if creaturesDiet1.count == 1 {
            print("LAST DIET 1 ONE")
            if creatures[creaturesDiet1[0]].alive == true {
                bestLayer_one_weights1 = creatures[creaturesDiet1[0]].brain.layer_one_weights
                bestLayer_two_weights1 = creatures[creaturesDiet1[0]].brain.layer_two_weights
                best_diet = creatures[creaturesDiet1[0]].diet
            }
        }
        
        if creatures.count == 1 {
            print("LAST ONE")
                if creatures[0].alive == true {
                    bestLayer_one_weights = creatures[0].brain.layer_one_weights
                    bestLayer_two_weights = creatures[0].brain.layer_two_weights
                    best_diet = creatures[0].diet
                }
        } else if creatures.isEmpty {
            print("all are dead")
            restart()
        }
        
        // Called before each frame is rendered
        //vzdialenost najblizsej potravy
        for i in 0...creatures.count - 1 {
            for j in 0...foods.count - 1 {
                let distance = creatures[i].position.distanceFromCGPoint(point: foods[j].position)
                distances[j] = distance
                mindist = distances.index(of: distances.min()!)!
            }
            shrtX[i] = foods[mindist].position.x
            shrtY[i] = foods[mindist].position.y
            distances.removeAll()
            for _ in 0...lunch {
                distances.append(9999.0)
            }
            creatures[i].color = SKColor(red: CGFloat(creatures[i].brain.output_nodes[1]),green: creatures[i].diet, blue: CGFloat(creatures[i].energy) / 1000 , alpha:1.0)
        }
        
        //vzdialenost najblizsej potravy od l-oka
        for i in 0...creatures.count - 1 {
            for j in 0...foods.count - 1 {
                let distance = creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: foods[j].position)
                distances[j] = distance!
                mindist = distances.index(of: distances.min()!)!
            }
            shrtL[i] = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: foods[mindist].position))!
            distances.removeAll()
            for _ in 0...lunch {
                distances.append(9999.0)
            }
        }
        
        //vzdialenost najblizsej potravy od p-oka
        for i in 0...creatures.count - 1 {
            for j in 0...foods.count - 1 {
                let distance = creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: foods[j].position)
                distances[j] = distance!
                mindist = distances.index(of: distances.min()!)!
            }
            shrtR[i] = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: foods[mindist].position))!
            distances.removeAll()
            for _ in 0...lunch {
                distances.append(9999.0)
            }
        }
        
        //vzdialenost najblizsieho kamena od l-oka
        for i in 0...creatures.count - 1 {
            for j in 0...stones.count - 1 {
                let distance = creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: stones[j].position)
                distancesS[j] = distance!
                mindistS = distancesS.index(of: distancesS.min()!)!
            }
            shrtLS[i] = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: stones[mindistS].position))!
            distancesS.removeAll()
            for _ in 0...soil {
                distancesS.append(9999.0)
            }
        }
        
        //vzdialenost najblizsieho kamena od p-oka
        for i in 0...creatures.count - 1 {
            for j in 0...stones.count - 1 {
                let distance = creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: stones[j].position)
                distancesS[j] = distance!
                mindistS = distancesS.index(of: distancesS.min()!)!
            }
            shrtRS[i] = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: stones[mindistS].position))!
            distancesS.removeAll()
            for _ in 0...soil {
                distancesS.append(9999.0)
            }
        }
        
        //vzdialenost najblizsej priserky
        for i in 0...creatures.count - 1 {
            for j in 0...creatures.count - 1 {
                if i == j {
                    let distance = CGFloat(9998.0)
                    distancesC[j] = distance
                } else {
                    let distance = creatures[i].position.distanceFromCGPoint(point: creatures[j].position)
                    distancesC[j] = distance
                }
                mindistC = distancesC.index(of: distancesC.min()!)!
            }
            shrtXC[i] = creatures[mindistC].position.x
            shrtYC[i] = creatures[mindistC].position.y
            colorCR[i] = creatures[mindistC].color.redComponent
            colorCG[i] = creatures[mindistC].color.redComponent
            colorCB[i] = creatures[mindistC].color.redComponent
            distancesC.removeAll()
            for _ in 0...500 {
                distancesC.append(9999.0)
            }
        }
        
        //vzdialenost najblizsej priserky od l-oka
        for i in 0...creatures.count - 1 {
            for j in 0...creatures.count - 1 {
                if i == j {
                    let distance = CGFloat(9998.0)
                    distancesC[j] = distance
                } else {
                    let distance = creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: creatures[j].position)
                    distancesC[j] = distance!
                }
                mindistC = distancesC.index(of: distancesC.min()!)!
            }
            shrtLC[i] = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: creatures[mindistC].position))!
            distancesC.removeAll()
            for _ in 0...500 {
                distancesC.append(9999.0)
            }
        }
        
        //vzdialenost najblizsej priserky od p-oka
        for i in 0...creatures.count - 1 {
            for j in 0...creatures.count - 1 {
                if i == j {
                    let distance = CGFloat(9998.0)
                    distancesC[j] = distance
                } else {
                    let distance = creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: creatures[j].position)
                    distancesC[j] = distance!
                }
                mindistC = distancesC.index(of: distancesC.min()!)!
            }
            shrtRC[i] = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: creatures[mindistC].position))!
            distancesC.removeAll()
            for _ in 0...500 {
                distancesC.append(9999.0)
            }
        }
        
        //zisti tazisko vsetkych jedal
        for i in 0...creatures.count - 1 {
            for j in 0...foods.count - 1 {
                tazx = tazx + (creatures[i].position.x - foods[j].position.x)
                tazy = tazy + (creatures[i].position.y - foods[j].position.y)
            }
            taziskox[i] = tazx / CGFloat(lunch)
            taziskoy[i] = tazy / CGFloat(lunch)
            tazx = 0
            tazy = 0
        }
        
        for number in 0...creatures.count-1 {
            creatures[number].name = "Creature" + String(number)
        }
        
        for i in 0...tracers.count - 1{
            //tracer zmena farby a vypocet
            for j in 0...foods.count - 1 {
                let distance = tracers[i].position.distanceFromCGPoint(point: foods[j].position)
                tracerColorG += 1/(distance)
            }
            for j in 0...creatures.count - 1 {
                let distance = tracers[i].position.distanceFromCGPoint(point:creatures[j].position)
                tracerColorB += 1/(distance)
            }
            for j in 0...stones.count - 1 {
                let distance = tracers[i].position.distanceFromCGPoint(point: stones[j].position)
                tracerColorR += 1/(distance)
            }
            tracers[i].fillColor = SKColor(red: 1 * tracerColorR , green: 1 * tracerColorG , blue: 1 * tracerColorB , alpha:1.0)
            tracerColorR = 0
            tracerColorG = 0
            tracerColorB = 0
        }
            
        //print(tracer.fillColor.redComponent)
        
        //pohni priserkami
        for i in 0...creatures.count - 1 {
            creatures[i].moveCreature(shrtY: shrtY[i], shrtX: shrtX[i], shrtYC: shrtYC[i], shrtXC: shrtXC[i], taziskox: taziskox[i], taziskoy: taziskoy[i], dead: &dead, colorCR: colorCR[i], colorCG: colorCG[i], colorCB: colorCB[i], shrtL: shrtL[i], shrtR: shrtR[i], shrtLC: shrtLC[i], shrtRC: shrtRC[i], shrtLS: shrtLS[i], shrtRS: shrtRS[i])
        }
        
        //pregnancy
        babies.removeAll()
        for i in 0...creatures.count - 1 {
            if creatures[i].pregnant_days > 30 && creatures.count < 300 {
                var baby = Creature()
                baby = addCreatureWithWeights(Layer1Weights: creatures[i].brain.layer_one_weights, Layer2Weights: creatures[i].brain.layer_two_weights, Diet: creatures[i].diet)
                baby.position = creatures[i].position
                creatures[i].energy -= 1000
                baby.energy = 1000
                babies.append(baby)
                creatures[i].pregnant = false
                creatures[i].pregnant_days = 0
            }
        }
        if babies.isEmpty == false {
            for i in 0...babies.count - 1 {
                creatures.append(babies[i])
            }
            for i in (creatures.count - babies.count)...(creatures.count - 1) {
                addChild(creatures[i])
            }
            for i in 0...creatures.count - 1 {
                creatures[i].name = "Creature" + String(i)
            }
            
            for i in 0...foods.count - 1 {
                foods[i].moveCreature()
            }
        }
        
        /*for i in 0...population {
         if creatures[i].brain.input_nodes[0] < Float(maxuhol) {
         maxuhol = Double(creatures[i].brain.input_nodes[0])
         print(maxuhol)
         }
         }*/
        
        if creatures.count == 1 {
            //print("LAST ONE")
                if creatures[0].alive == true {
                    bestLayer_one_weights = creatures[0].brain.layer_one_weights
                    bestLayer_two_weights = creatures[0].brain.layer_two_weights
                    best_diet = creatures[0].diet
                }
        } else if creatures.isEmpty {
            //print("all are dead")
            restart()
        }
    }
    
    func restart() {
        
        self.removeAllChildren()
        generation += 1
        gentext = String(generation)
        GenerationLabel.text = "Generation" + gentext
        addChild(GenerationLabel)
        shrtX.removeAll()
        shrtY.removeAll()
        shrtL.removeAll()
        shrtR.removeAll()
        shrtXC.removeAll()
        shrtYC.removeAll()
        shrtLC.removeAll()
        shrtRC.removeAll()
        shrtLS.removeAll()
        shrtRS.removeAll()
        colorCR.removeAll()
        colorCG.removeAll()
        colorCB.removeAll()
        taziskox.removeAll()
        taziskoy.removeAll()
        for _ in 0...1000 {
            shrtX.append(1)
            shrtY.append(1)
            shrtL.append(1)
            shrtR.append(1)
            shrtXC.append(1)
            shrtYC.append(1)
            shrtLC.append(1)
            shrtRC.append(1)
            shrtLS.append(1)
            shrtRS.append(1)
            colorCR.append(1)
            colorCG.append(1)
            colorCB.append(1)
        }
        
        distances.removeAll()
        for _ in 0...lunch {
            distances.append(9999.0)
        }
        distancesC.removeAll()
        distancesS.removeAll()
        for _ in 0...1000 {
            distancesC.append(9999)
            distancesS.append(9999)
        }
       
        for _ in 0...1000 {
            taziskox.append(0)
            taziskoy.append(0)
        }
        
        foods.removeAll()
        for number in 0...lunch {
            foods.append(addFood())
            foods[number].name = "Food" + String(number)
            addChild(foods[number])
        }
        
        stones.removeAll()
        for number in 0...soil {
            stones.append(addStones())
            addChild(stones[number])
        }
        
        creatures.removeAll()
        for number in 0...(population + 1)/2 - 1 {
            if (bestLayer_one_weights0.isEmpty && bestLayer_two_weights0.isEmpty) {
                creatures.append(addCreature(Diet: 0.0))
            } else {
                creatures.append(addCreatureWithWeights(Layer1Weights: bestLayer_one_weights0, Layer2Weights: bestLayer_two_weights0, Diet: 0.0))
            }
            creatures[number].name = "Creature" + String(number)
            addChild(creatures[number])
        }
        for number in (population + 1)/2...(population + 1)/2 + (population + 1)/2 - 1 {
            if (bestLayer_one_weights1.isEmpty && bestLayer_two_weights1.isEmpty) {
                creatures.append(addCreature(Diet: 1.0))
            } else {
                creatures.append(addCreatureWithWeights(Layer1Weights: bestLayer_one_weights1, Layer2Weights: bestLayer_two_weights1, Diet: 1.0))
            }
            creatures[number].name = "Creature" + String(number)
            addChild(creatures[number])
        }
        dead = 0
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addCreature(Diet: CGFloat) -> Creature {
        
        // Create sprite
        let creature = Creature(imageNamed: "potvorka")
        // Determine where to spawn the monster along the Y and X axis
        let actualY = random(min: 5, max: 795)
        let actualX = random(min: 5, max: 795)
        var r = CGFloat.random(in: 0 ..< 1)
        /*if r < 0.5 {
         r = 0
         } else {r = 1}*/
        creature.diet = Diet
        // Position the monster
        creature.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        creature.color = SKColor.yellow
        creature.colorBlendFactor = 0.5
        creature.size = CGSize(width: 4,height: 4)
        creature.blendMode = .replace
        //Eyes
        creature.addEyes()
        // Collision
        creature.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4,height: 4))
        creature.physicsBody?.affectedByGravity = false
        creature.physicsBody?.isDynamic = true
        creature.physicsBody?.categoryBitMask = ColliderType.Creature
        creature.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Creature
        
        // Add the monster to the scene
        return creature
    }
    
    func addCreatureWithWeights(Layer1Weights: [Float], Layer2Weights: [Float], Diet: CGFloat) -> Creature {
        
        // Create sprite
        let creature = Creature(imageNamed: "potvorka")
        // Determine where to spawn the monster along the Y and X axis
        let actualY = random(min: 5, max: 795)
        let actualX = random(min: 5, max: 795)
        let rand = arc4random()%UInt32(9)
        if rand == 1 {
            var r = CGFloat.random(in: 0 ..< 1)
            /*if r < 0.5 {
             r = 0
             } else {r = 1}*/
            creature.diet = Diet
            print("mutoval diet na:",r)
        } else {
            creature.diet = Diet
        }
        // Position the monster
        creature.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        creature.color = SKColor.yellow
        creature.colorBlendFactor = 0.5
        creature.size = CGSize(width: 4,height: 4)
        creature.blendMode = .replace
        //Eyes
        creature.addEyes()
        // Collision
        creature.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4,height: 4))
        creature.physicsBody?.affectedByGravity = false
        creature.physicsBody?.isDynamic = true
        creature.physicsBody?.categoryBitMask = ColliderType.Creature
        creature.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Creature
        // Update brain
        creature.updateCreatureBrain(layer1Weights: Layer1Weights, layer2Weights: Layer2Weights)
        
        // Add the monster to the scene
        return creature
    }
    
    func addFood() -> Food {
        
        // Create sprite
        let food = Food(rectOf: CGSize.init(width: 4, height: 4))
        
        // Determine where to spawn the food along the Y and X axis
        let actualY = random(min: 5, max: 795)
        let actualX = random(min: 5, max: 795)
        
        // Position the food
        food.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        food.fillColor = SKColor.green
        food.lineWidth = 0
        food.name = "Food"
        food.blendMode = .replace
        
        // Collision
        food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4,height: 4))
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = true
        food.physicsBody?.categoryBitMask = ColliderType.Food
        
        // Add the food to the scene
        return food
    }
    
    func addStones() -> Stone {
        
        // Create sprite
        let stone = Stone(rectOf: CGSize.init(width: 6, height: 6))
        
        // Determine where to spawn the food along the Y and X axis
        let actualY = random(min: 5, max: 795)
        let actualX = random(min: 5, max: 795)
        
        // Position the food
        stone.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        stone.fillColor = SKColor.brown
        stone.lineWidth = 0
        stone.name = "Stone"
        stone.blendMode = .replace
        
        // Collision
        stone.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 6,height: 6))
        stone.physicsBody?.affectedByGravity = false
        stone.physicsBody?.isDynamic = true
        stone.physicsBody?.categoryBitMask = ColliderType.Stone
        
        // Add the food to the scene
        return stone
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if (contact.bodyA.node?.name?.hasPrefix("Creature"))! {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.node?.name?.hasPrefix("Creature"))! && (secondBody.node?.name?.hasPrefix("Food"))! {
            let abcd12 = (firstBody.node!.name)!
            let numero = (abcd12.dropFirst(8) as NSString).integerValue
            print("CONTACT", numero)
            let abcd34 = (secondBody.node!.name)!
            let numero2 = (abcd34.dropFirst(4) as NSString).integerValue
            creatures[numero].energy += Double(100 * creatures[numero].diet)
            foods[numero2].energy -= Double(100 * creatures[numero].diet)
            //foods[numero2].position.x = random(min: 5, max: 995)
            //foods[numero2].position.y = random(min: 5, max: 795)
            //secondBody.node?.removeFromParent()
            if foods[numero2].energy < 0.0 {
                let movex = SKAction.moveTo(x: random(min: 5, max: 795), duration: 0.0)
                let movey = SKAction.moveTo(y: random(min: 5, max: 795), duration: 0.0)
                secondBody.node?.run(movex)
                secondBody.node?.run(movey)
                foods[numero2].energy = 100.0
            }
        }
        
        if (firstBody.node?.name?.hasPrefix("Creature"))! && (secondBody.node?.name?.hasPrefix("Creature"))! {
            let abcd12 = (firstBody.node!.name)!
            let numero = (abcd12.dropFirst(8) as NSString).integerValue
            let abcd34 = (secondBody.node!.name)!
            let numero2 = (abcd34.dropFirst(8) as NSString).integerValue
            print("TOUCH", numero , numero2)
            creatures[numero].energy += Double(100 * ( -creatures[numero].diet + creatures[numero2].diet))
            creatures[numero2].energy +=  Double(100 * ( -creatures[numero2].diet + creatures[numero].diet))
        }
    }
}

extension SKShapeNode {
    var positionInScene:CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to: scene)
        } else {
            return nil
        }
    }
}
*/
