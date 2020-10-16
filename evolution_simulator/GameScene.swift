//
//  GameScene.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import SpriteKit
import GameplayKit
import Carbon

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
    
    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_ANSI_I:
            self.camera?.xScale -= 0.1
            self.camera?.yScale -= 0.1
            print("pressed ",event.keyCode)
            break
            
        case kVK_ANSI_O:
            self.camera?.xScale += 0.1
            self.camera?.yScale += 0.1
            print("pressed ",event.keyCode)
            break
            
        case kVK_ANSI_A:
            self.camera?.position.x -= 10
            print("pressed ",event.keyCode)
            break
            
        case kVK_ANSI_D:
            self.camera?.position.x += 10
            print("pressed ",event.keyCode)
            break
            
        case kVK_ANSI_S:
            self.camera?.position.y -= 10
            print("pressed ",event.keyCode)
            break
            
        case kVK_ANSI_W:
            self.camera?.position.y += 10
            print("pressed ",event.keyCode)
            break
            
        default:
            // ignore unsupported keys
            break
        }
    }
    
    var notifObservers = [NSObjectProtocol]()
    var prefs = Preferences()
    let Swidth = 800
    let Sheight = 800
    var population = 30
    var lastPopulation = 0
    var creaturesNumber = [Int]()
    var lunch = 100
    var soil = 24
    var creatures = [Player]()
    var deadCreatures = [Player]()
    var nextGen = [Player]()
    var species = [Species]()
    //var lefteyes = [SKShapeNode]()
    //var righteyes = [SKShapeNode]()
    //var middleeyes = [SKShapeNode]()
    var stones = [Stone]()
    var excessEnergy = 0.0
    var remove = [Int]()
    var babies = [Player]()
    var foods = [Food]()
    var distances = [CGFloat]()
    var mindist = CGFloat()
    var mindist2 = Int()
    var shrtX = [CGFloat]()
    var shrtY = [CGFloat]()
    //eyes
    var shrtL = [CGFloat]()
    var shrtR = [CGFloat]()
    var shrtM = [CGFloat]()
    var distancesC = [CGFloat]()
    var mindistC = Int()
    var shrtXC = [CGFloat]()
    var shrtYC = [CGFloat]()
    var shrtLC = [CGFloat]()
    var shrtRC = [CGFloat]()
    var shrtMC = [CGFloat]()
    var distancesS = [CGFloat]()
    var mindistS = CGFloat()
    var shrtLS = [CGFloat]()
    var shrtRS = [CGFloat]()
    var shrtMS = [CGFloat]()
    var colorCR = [CGFloat]()
    var colorCG = [CGFloat]()
    var colorCB = [CGFloat]()
    var dead = 0
    var bestBrain = Genome(genomeInputs: 1, genomeOutputs: 1)
    var best_diet = CGFloat()
    var generation = 1
    var gentext = String()
    let GenerationLabel = SKLabelNode(text: "Born :" )
    let BestPlayerLabel = SKLabelNode(text: "Health :" )
    var taziskox = [CGFloat]()
    var taziskoy = [CGFloat]()
    var tazx = CGFloat()
    var tazy = CGFloat()
    var maxAge = [Int]()
    var maxAgeF = [Int]()
    var maxAgeFposition = CGPoint()
    var lastMaxAge = Genome(genomeInputs: 1, genomeOutputs: 1)
    var bestLastMaxAge = Int()
    var randoms = [Int]()
    var born = 0
    var time = 0.0
    var drawnNodes = [SKNode]()
    var oldestCreature = [Any]()
    var bestAge = Int()
    //let myUnit = ToneOutputUnit()
    var innovationHistory = [Connection]()
    let kamera = SKCameraNode()
    var activationSwitch = true
    
    override func sceneDidLoad() {
        setupPrefs()
    }
    
    override func didMove(to view: SKView) {
        
        kamera.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(kamera)
        self.camera = kamera
        self.camera?.isUserInteractionEnabled = true
        
        gentext = String(generation)
        GenerationLabel.position.x = -self.size.width/2 + 30
        GenerationLabel.position.y = -self.size.height/2 + 30
        GenerationLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        GenerationLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        GenerationLabel.fontSize = 14
        GenerationLabel.text = "Born :" + String(born) + "Time :" + String(time / 60)
        kamera.addChild(GenerationLabel)
        
        BestPlayerLabel.position.x = -self.size.width/2 + 30
        BestPlayerLabel.position.y = GenerationLabel.position.y + 250
        BestPlayerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        BestPlayerLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        BestPlayerLabel.fontSize = 12
        BestPlayerLabel.text = "Health :" + "Fat :"
        kamera.addChild(BestPlayerLabel)
        
        creaturesNumber.append(0)
        creaturesNumber.append(0)
        
        self.physicsWorld.contactDelegate = self
        
        for _ in 0...500 {
            shrtX.append(1)
            shrtY.append(1)
            shrtL.append(1)
            shrtR.append(1)
            shrtM.append(1)
            shrtXC.append(1)
            shrtYC.append(1)
            shrtLC.append(1)
            shrtRC.append(1)
            shrtMC.append(1)
            shrtLS.append(1)
            shrtRS.append(1)
            shrtMS.append(1)
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
        
        for number in 0..<lunch {
            foods.append(addFood())
            foods[number].name = "Food" + String(number)
            addChild(foods[number])
        }
        
        for number in 0..<soil {
            stones.append(addStones())
            addChild(stones[number])
        }
        
        for number in 0..<population {
            if bestBrain.nodes.count == 2 {
                creatures.append(addCreature())
                if innovationHistory.isEmpty {
                    for i in 0..<creatures[number].brain.connections.count {
                        innovationHistory.append(creatures[number].brain.connections[i])
                    }
                }
            } else {
                creatures.append(addCreatureWithWeights(Brain: bestBrain, Diet: best_diet, Div_1: 1, Div_2: 2))
            }
            creatures[number].name = "Creature" + String(number)
            addChild(creatures[number])
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        /*for i in 0..<creatures.count {
         if !creatures[i].alive {
         remove.append(i)
         }
         }
         if !remove.isEmpty {
         for i in (0...remove.count - 1).reversed() {
         creatures.remove(at: remove[i])
         }
         }
         remove.removeAll()
         
         if creatures.count == 1 {
         print("LAST ONE")
         if creatures[0].alive == true {
         //mozog poslednej sa skopíruje do best
         bestBrain = creatures[0].brain
         best_diet = creatures[0].diet
         }
         } else if creatures.isEmpty {
         print("all are dead")
         restart()
         }*/
        
        // Called before each frame is rendered
        maxAge.removeAll()
        for i in 0..<creatures.count {
            maxAge.append(creatures[i].age)
            if !creatures[i].contactsf.isEmpty {
                //print("creature \(i) touches food \(creatures[i].contactsf)")
                for j in creatures[i].contactsf {
                    if creatures[i].hate > 0.5 { // ak potvorka hejtuje 
                        //creatures[i].energy += Double(100 * creatures[i].diet)
                        //foods[j].energy -= Double(100 * creatures[i].diet)
                        if creatures[i].age > 1000 {
                            creatures[i].fat += Double(300 * (-creatures[i].diet + 1))
                        } else {
                            creatures[i].maxHealth += Double(300 * (-creatures[i].diet + 1))
                            creatures[i].health += Double(300 * (-creatures[i].diet + 1))
                        }
                        foods[j].energy -= Double(300 * (-creatures[i].diet + 1))
                        if foods[j].energy < 0.0 {
                            excessEnergy += abs(foods[j].energy)
                            foods[j].energy = 0.0
                            let rand = arc4random()%UInt32(29)
                            if rand > 20 {
                                let random = GKRandomSource()
                                let randGaussY = GKGaussianDistribution(randomSource: random, lowestValue: -300, highestValue: 300)//(Swidth + 2))
                                let randGaussX = GKGaussianDistribution(randomSource: random, lowestValue: -300, highestValue: 300) //(Sheight + 2))
                                if maxAgeF.isEmpty {
                                    let movex = SKAction.moveTo(x: CGFloat(foods[j].position.x + CGFloat(randGaussX.nextInt())), duration: 0.0)
                                    let movey = SKAction.moveTo(y: CGFloat(foods[j].position.y + CGFloat(randGaussY.nextInt())), duration: 0.0)
                                    foods[j].run(movex)
                                    foods[j].run(movey)
                                } else {
                                    let movex = SKAction.moveTo(x: CGFloat(maxAgeFposition.x + CGFloat(randGaussX.nextInt())), duration: 0.0)
                                    let movey = SKAction.moveTo(y: CGFloat(maxAgeFposition.y + CGFloat(randGaussY.nextInt())), duration: 0.0)
                                    foods[j].run(movex)
                                    foods[j].run(movey)
                                }
                            } else {
                                let random = GKRandomSource()
                                let randGaussY = GKGaussianDistribution(randomSource: random, lowestValue: -290, highestValue: (Swidth + 290))
                                let randGaussX = GKGaussianDistribution(randomSource: random, lowestValue: -290, highestValue: (Sheight + 290))
                                let actualY = SKAction.moveTo(y: CGFloat(randGaussY.nextInt()), duration: 0.0)
                                let actualX = SKAction.moveTo(x: CGFloat(randGaussX.nextInt()), duration: 0.0)
                                foods[j].run(actualX)
                                foods[j].run(actualY)
                            }
                            //foods[j].energy = 300.0
                            creatures[i].contactsf.remove(j)
                        }
                    }
                }
            }
            if creatures[i].alive {
                if creatures[i].outputs.count != 0 {
                    //creatures[i].color = SKColor(red: CGFloat(creatures[i].outputs[2]),green: CGFloat(creatures[i].outputs[3]), blue: CGFloat(creatures[i].diet) , alpha:1.0)
                    creatures[i].color = SKColor(red: CGFloat(creatures[i].attackBonus/3),green: CGFloat(creatures[i].speedBonus/3), blue: CGFloat(creatures[i].defenseBonus/3) , alpha:1.0)
                }
            } else {
                creatures[i].color = SKColor(white: 1, alpha: 1)
            }
            //creatures[i].color = SKColor(hue: CGFloat(creatures[i].diet), saturation: CGFloat(1), brightness: CGFloat(creatures[i].energy / 1000), alpha: 1.0)
            
            creatures[i].brain.placeNodes()
        }
        if oldestCreature.isEmpty {
            for i in 0..<maxAge.count {
                for j in 0..<maxAge.count {
                    if creatures[i].age > maxAge[j] {
                        oldestCreature.removeAll()
                        oldestCreature.append(creatures[i].brain)
                        oldestCreature.append(creatures[i].diet)
                        bestAge = creatures[i].age
                    }
                }
            }
        }
        for i in 0..<creatures.count {
            if creatures[i].age > bestAge {
                oldestCreature.removeAll()
                oldestCreature.append(creatures[i].brain)
                oldestCreature.append(creatures[i].diet)
                bestAge = creatures[i].age
            }
        }
        
        if lastMaxAge.connections != creatures[maxAge.firstIndex(of: maxAge.max()!)!].brain.connections {
            //print("Last oldest Creature died at age:", bestLastMaxAge )
            creaturesNumber.append(bestLastMaxAge)
            //print("Oldest Creature age:", creatures[maxAge.firstIndex(of: maxAge.max()!)!].age)
            //print("Oldest Creature Brain:", creatures[maxAge.firstIndex(of: maxAge.max()!)!].brain.connections)
        }
        lastMaxAge = creatures[maxAge.firstIndex(of: maxAge.max()!)!].brain
        bestLastMaxAge = creatures[maxAge.firstIndex(of: maxAge.max()!)!].age
        
        maxAgeF.removeAll()
        //rast rastlín
        for j in 0..<foods.count {
            //print(foods[j].energy)
            if foods[j].energy <= 299.5 {
                if excessEnergy >= 0.5 {
                    foods[j].energy += 0.5
                    excessEnergy -= 0.5
                } else {
                    foods[j].energy += excessEnergy
                    excessEnergy = 0
                }
            } else if foods[j].energy < 300 {
                if excessEnergy >= 300-foods[j].energy {
                    foods[j].energy += 300-foods[j].energy
                    excessEnergy -= 300-foods[j].energy
                } else {
                    foods[j].energy += excessEnergy
                    excessEnergy = 0
                }
            }
            maxAgeF.append(foods[j].age)
            maxAgeFposition = foods[maxAgeF.firstIndex(of: maxAgeF.max()!)!].position
        }
        
        //VNIMANIE
        for i in 0..<creatures.count {
            if creatures[i].alive {
                //a to nieco je jedlo
                var mindistFL = CGFloat(0.0)
                var mindistFR = CGFloat(0.0)
                var mindistFM = CGFloat(0.0)
                for j in 0..<foods.count {
                    //uhol jedla
                    var angle = (atan2(foods[j].position.y - creatures[i].position.y , foods[j].position.x - creatures[i].position.x) - creatures[i].zRotation)
                    if angle < -.pi { angle += .pi*2 }
                    if angle > .pi { angle -= .pi*2 }
                    //lave oko
                    if true { //angle < -.pi/2 || angle >= .pi/2 {
                        let distance = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: foods[j].position))!
                        mindistFL += CGFloat(0.05*foods[j].energy) / (distance+0.000001)
                    }
                    //prave oko
                    if true { //angle <= .pi/2 && angle > -.pi/2 {
                        let distance = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: foods[j].position))!
                        mindistFR += CGFloat(0.05*foods[j].energy)/(distance+0.000001)
                    }
                    //stredne oko
                    if true { //angle < .pi && angle > 0 {
                        let distance = (creatures[i].eyes[2].positionInScene?.distanceFromCGPoint(point: foods[j].position))!
                        mindistFM += CGFloat(0.05*foods[j].energy)/(distance+0.000001)
                    }
                }
                // a nasleduju kamene
                var mindistSL = CGFloat(0.0)
                var mindistSR = CGFloat(0.0)
                var mindistSM = CGFloat(0.0)
                for j in 0..<stones.count {
                    //uhol kamenov
                    var angle = (atan2(stones[j].position.y - creatures[i].position.y , stones[j].position.x - creatures[i].position.x) - creatures[i].zRotation)
                    if angle < -.pi { angle += .pi*2 }
                    if angle > .pi { angle -= .pi*2 }
                    //lave oko
                    if true { //angle < -.pi/2 || angle >= .pi/2 {
                        let distance = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: stones[j].position))!
                        mindistSL += 15/(distance+0.000001)
                    }
                    //prave oko
                    if true { //angle <= .pi/2 && angle > -.pi/2 {
                        let distance = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: stones[j].position))!
                        mindistSR += 15/(distance+0.000001)
                    }
                    //stredne oko
                    if true { //angle < .pi && angle > 0 {
                        let distance = (creatures[i].eyes[2].positionInScene?.distanceFromCGPoint(point: stones[j].position))!
                        mindistSM += 15/(distance+0.000001)
                    }
                }
                //teraz kreaturky
                var mindistCL = CGFloat(0.0)
                var mindistCR = CGFloat(0.0)
                var mindistCM = CGFloat(0.0)
                var mindistCLR = CGFloat(0.0)
                var mindistCRR = CGFloat(0.0)
                var mindistCMR = CGFloat(0.0)
                var mindistCLG = CGFloat(0.0)
                var mindistCRG = CGFloat(0.0)
                var mindistCMG = CGFloat(0.0)
                var mindistCLB = CGFloat(0.0)
                var mindistCRB = CGFloat(0.0)
                var mindistCMB = CGFloat(0.0)
                for j in 0..<creatures.count {
                    if creatures[j].alive {
                        //uhol priserky
                        var angle = (atan2(creatures[j].position.y - creatures[i].position.y , creatures[j].position.x - creatures[i].position.x) - creatures[i].zRotation)
                        if angle < -.pi { angle += .pi*2 }
                        if angle > .pi { angle -= .pi*2 }
                        //lave oko
                        if true { //angle < -.pi/2 || angle >= .pi/2 {
                            var distance = (creatures[i].eyes[0].positionInScene?.distanceFromCGPoint(point: creatures[j].position))!
                            var red = creatures[j].color.redComponent
                            var green = creatures[j].color.greenComponent
                            var blue = creatures[j].color.blueComponent
                            if i == j {
                                distance = CGFloat(9999999.0)
                                red = 0
                                green = 0
                                blue = 0
                            }
                            mindistCL += 15/(distance+0.000001)
                            mindistCLR += 15*red/(distance+0.000001)
                            mindistCLG += 15*green/(distance+0.000001)
                            mindistCLB += 15*blue/(distance+0.000001)
                        }
                        //prave oko
                        if true { //angle <= .pi/2 && angle > -.pi/2 {
                            var distance = (creatures[i].eyes[1].positionInScene?.distanceFromCGPoint(point: creatures[j].position))!
                            var red = creatures[j].color.redComponent
                            var green = creatures[j].color.greenComponent
                            var blue = creatures[j].color.blueComponent
                            if i == j {
                                distance = CGFloat(9999999.0)
                                red = 0
                                green = 0
                                blue = 0
                            }
                            mindistCR += 15/(distance+0.000001)
                            mindistCRR += 15*red/(distance+0.000001)
                            mindistCRG += 15*green/(distance+0.000001)
                            mindistCRB += 15*blue/(distance+0.000001)
                        }
                        //stredne oko
                        if true { //angle < .pi && angle > 0 {
                            var distance = (creatures[i].eyes[2].positionInScene?.distanceFromCGPoint(point: creatures[j].position))!
                            var red = creatures[j].color.redComponent
                            var green = creatures[j].color.greenComponent
                            var blue = creatures[j].color.blueComponent
                            if i == j {
                                distance = CGFloat(9999999.0)
                                red = 0
                                green = 0
                                blue = 0
                            }
                            mindistCM += 15/(distance+0.000001)
                            mindistCMR += 15*red/(distance+0.000001)
                            mindistCMG += 15*green/(distance+0.000001)
                            mindistCMB += 15*blue/(distance+0.000001)
                        }
                    }
                }
                //vsetky premenne nacitaj
                shrtL[i] = mindistFL
                shrtR[i] = mindistFR
                shrtM[i] = mindistFM
                shrtLS[i] = mindistSL
                shrtRS[i] = mindistSR
                shrtMS[i] = mindistSM
                shrtLC[i] = mindistCL
                shrtRC[i] = mindistCR
                shrtMC[i] = mindistCM
                colorCR[i] = (mindistCLR+mindistCRR+mindistCMR)/3
                colorCG[i] = (mindistCLG+mindistCRG+mindistCMG)/3
                colorCB[i] = (mindistCLB+mindistCRB+mindistCMB)/3
                //nastav meno
                creatures[i].name = "Creature" + String(i)
            }
        }
        
        //pohni priserkami
        babies.removeAll()
        for i in 0..<creatures.count {
            //if creatures[i].alive {print("Creature: ", i)}
            creatures[i].moveCreature(shrtY: shrtY[i], shrtX: shrtX[i], shrtYC: shrtYC[i], shrtXC: shrtXC[i], dead: &dead, colorCR: colorCR[i], colorCG: colorCG[i], colorCB: colorCB[i], shrtL: shrtL[i], shrtR: shrtR[i], shrtM: shrtM[i], shrtLC: shrtLC[i], shrtRC: shrtRC[i], shrtMC: shrtMC[i], shrtLS: shrtLS[i], shrtRS: shrtRS[i], shrtMS: shrtMS[i], excessEnergy: &excessEnergy)
            
            if creatures[i].alive {
                if creatures[i].pregnant_days > 100 && creatures.count < 100 {
                    //odmeň príšerku
                    //creatures[i].age += 5000
                    //birth stuf
                    var baby = Player()
                    if creatures[i].babyBrain.inputs == 30 && creatures[i].babyDiet == 2 {
                        baby = addCreatureWithWeights(Brain: creatures[i].brain, Diet: creatures[i].diet, Div_1: creatures[i].div_1, Div_2: creatures[i].div_2)
                    } else {
                        baby = addCreatureWithWeights(Brain: creatures[i].babyBrain, Diet: creatures[i].babyDiet, Div_1: creatures[i].div_1, Div_2: creatures[i].div_2)
                    }
                    baby.position = creatures[i].position
                    if creatures[i].fat+creatures[i].health >= 1000 {
                        //creatures[i].energy -= 3000
                        //baby.energy = creatures[i].energy / 2
                        creatures[i].fat -= 1000
                        baby.fat = 1000
                    } else {
                        //baby.energy = creatures[i].energy / 2
                        //creatures[i].energy = creatures[i].energy / 2
                        creatures[i].fat -= creatures[i].fat/2
                        baby.fat = creatures[i].fat/2
                    }
                    babies.append(baby)
                    creatures[i].pregnant = false
                    creatures[i].pregnant_days = 0
                }
                if creatures[i].pregnant_days > 102 {
                    creatures[i].pregnant = false
                }
            }
            
            if !creatures[i].alive {
                deadCreatures.append(creatures[i])
                creatures[i].color = SKColor(white: 1, alpha: 1)
                creatures[i].removeFromParent()
            }
        }
        
        for i in 0..<foods.count {
            foods[i].moveCreature()
        }
        
        //pregnancy
        if !babies.isEmpty {
            for i in 0...babies.count - 1 {
                creatures.append(babies[i])
            }
            for i in (creatures.count - babies.count)...(creatures.count - 1) {
                born += 1
                addChild(creatures[i])
            }
            for i in 0...creatures.count - 1 {
                creatures[i].name = "Creature" + String(i)
            }
        }
        //print(creaturesNumber)
        //draw brain
        for i in 0..<drawnNodes.count {
            drawnNodes[i].removeFromParent()
        }
        drawnNodes.removeAll()
        draw_brain(creature: creatures[maxAge.firstIndex(of: maxAge.max()!)!])
        /*if lastPopulation != bestLastMaxAge {
         creaturesNumber.append(bestLastMaxAge)
         }*/
        draw_population(numbers: creaturesNumber)
        if creaturesNumber.count > 299 {
            //creaturesNumber.removeFirst()
        }
        //lastPopulation = bestLastMaxAge
        //creatures[maxAge.index(of: maxAge.max()!)!].signals[3].fillColor = SKColor.yellow
        
        //create random creatures
        /*babies.removeAll()
         if creatures.count < population {
         var baby = Player()
         let rand = arc4random()%UInt32(9)
         if rand < 4 || oldestCreature.isEmpty {
         baby = addCreature()
         } else {
         baby = addCreatureWithWeights(Brain: oldestCreature[0] as! Genome, Diet: oldestCreature[1] as! CGFloat)
         //baby = addCreature()
         }
         baby.energy = 3000
         babies.append(baby)
         }
         if !babies.isEmpty {
         for i in 0..<babies.count {
         creatures.append(babies[i])
         }
         for i in (creatures.count - babies.count)...(creatures.count - 1) {
         addChild(creatures[i])
         }
         for i in 0...creatures.count - 1 {
         creatures[i].name = "Creature" + String(i)
         }
         }*/
        
        /*if creatures.count == 1 {
         //print("LAST ONE")
         if creatures[0].alive {
         bestBrain = creatures[0].brain
         best_diet = creatures[0].diet
         }
         } else if creatures.isEmpty {
         //print("all are dead")
         restart()
         }*/
        
        time += 1
        GenerationLabel.numberOfLines = 0
        if species.count == 0 {
            GenerationLabel.text = "Born :" + String(born) + "\nTime :" + String((time).rounded()) + "\nPopulation :" + String(creatures.count) + "\nbestAge :" + String(bestAge)
        } else {
            GenerationLabel.text = "Born :" + String(born) + "\nTime :" + String((time).rounded()) + "\nPopulation :" + String(creatures.count) + "\nbestAge :" + String(bestAge) + "\nSpecies :" + String(species.count)
            for s in 0..<species.count {
                GenerationLabel.text! += "\n" + String(s) + ". best age: " + String(species[s].bestFitness) + " staleness: " + String(species[s].staleness) + " members: " + String(species[s].players.count)
            }
        }
        
        //umreli?
        if deadCreatures.count > population {
            deadCreatures.removeFirst()
        }
        
        creatures.removeAll(where: {!$0.alive } )
        for i in 0..<creatures.count {
            creatures[i].name = "Creature" + String(i)
        }
        
        if creatures.count < population {
            naturalSelection()
            for i in 0..<species.count {
                print("druh ",i ,"naj-", species[i].bestFitness,"priemer-", species[i].averageFitness,"bez vylepsenia-", species[i].staleness)
            }
            //var agesSum = 0
            var fitnessSum = 0
            //var tresholds = [Int]()
            var fitnessTresholds = [Int]()
            /*for i in 0..<deadCreatures.count {
             agesSum += deadCreatures[i].age
             tresholds.append(agesSum)
             }*/
            for s in species {
                fitnessSum += s.averageFitness
                fitnessTresholds.append(fitnessSum)
            }
            //var randAgesSum = 0
            var randFitnessSum = 0
            var randPlayer = 0
            nextGen.removeAll()
            let averageSum = self.getAvgFitnessSum()
            for j in 0..<self.species.count { //for each self.species
                nextGen.append(self.species[j].champ); //add champion without any mutation
                let NoOfChildren = Int(Double(species[j].averageFitness) / Double(averageSum) * Double(deadCreatures.count));
                for _ in 0..<NoOfChildren { //get the calculated amount of children from this self.species
                    nextGen.append(self.species[j].giveMeBaby(innovationHistory: &self.innovationHistory));
                }
            }
            
            
            /*for _ in 0..<population - creatures.count {
             //randAgesSum = Int.random(in: 0 ... agesSum)
             randFitnessSum = Int.random(in: 0 ... fitnessSum)
             randPlayer = Int.random(in: 0 ... species[nextGenParent(randAgesSum: randFitnessSum , tresholds: fitnessTresholds)].players.count-1)
             //nextGen.append(deadCreatures[nextGenParent(randAgesSum: randAgesSum , tresholds: tresholds)])
             nextGen.append(species[nextGenParent(randAgesSum: randFitnessSum , tresholds: fitnessTresholds)].players[randPlayer])
             }*/
            let creaturesNo = creatures.count
            for i in 0..<nextGen.count {
                let rand = arc4random()%UInt32(29)
                if rand < 2 {
                    creatures.append(addCreature())
                } else {
                    let newCreature = addCreatureWithWeights(Brain: nextGen[i].brain, Diet: nextGen[i].diet, Div_1: nextGen[i].div_1, Div_2: nextGen[i].div_2)
                    let random = GKRandomSource()
                    let randGaussY = GKGaussianDistribution(randomSource: random, lowestValue: -100, highestValue: 100)
                    let randGaussX = GKGaussianDistribution(randomSource: random, lowestValue: -100, highestValue: 100)
                    newCreature.position.x = nextGen[i].lastPosition.x + CGFloat(randGaussX.nextInt())
                    newCreature.position.y = nextGen[i].lastPosition.y + CGFloat(randGaussY.nextInt())
                    creatures.append(newCreature)
                }
                creatures[creaturesNo + i].name = "Creature" + String(creaturesNo + i)
                addChild(creatures[creaturesNo + i])
            }
            
        }
        
        if umreli() {
            //sčíta vek príšer a do pola dá hraničné pozície
            /*var agesSum = 0
             var tresholds = [Int]()
             for i in 0..<deadCreatures.count {
             agesSum += deadCreatures[i].age
             tresholds.append(agesSum)
             }
             var randAgesSum = 0
             nextGen.removeAll()
             for _ in 0..<population {
             randAgesSum = Int.random(in: 0 ... agesSum)
             nextGen.append(deadCreatures[nextGenParent(randAgesSum: randAgesSum , tresholds: tresholds)])
             }*/
            naturalSelection()
            var fitnessSum = 0
            var fitnessTresholds = [Int]()
            for s in species {
                fitnessSum += s.averageFitness
                fitnessTresholds.append(fitnessSum)
            }
            var randFitnessSum = 0
            nextGen.removeAll()
            for _ in 0..<population - creatures.count {
                randFitnessSum = Int.random(in: 0 ... fitnessSum)
                nextGen.append(species[nextGenParent(randAgesSum: randFitnessSum , tresholds: fitnessTresholds)].champ)
            }
            restart(nextGeneration: nextGen, new: false)
        }
        setupPrefs()
    }
    
    func restart(nextGeneration: [Player], new: Bool) {
        print("restarting")
        self.removeAllChildren()
        kamera.removeAllChildren()
        print("removed all children")
        kamera.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(kamera)
        self.camera = kamera
        self.camera?.isUserInteractionEnabled = true
        print("added camera")
        if new {
            generation = 0
        } else {
            generation += 1
        }
        gentext = String(generation)
        GenerationLabel.position.x = -self.size.width/2 + 30
        GenerationLabel.position.y = -self.size.height/2 + 30
        GenerationLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        GenerationLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        GenerationLabel.fontSize = 14
        GenerationLabel.text = "Born :" + String(born) + "Time :" + String(time / 60)
        kamera.addChild(GenerationLabel)
        print("generation label added")
        BestPlayerLabel.position.x = -self.size.width/2 + 30
        BestPlayerLabel.position.y = GenerationLabel.position.y + 250
        BestPlayerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        BestPlayerLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        BestPlayerLabel.fontSize = 12
        BestPlayerLabel.text = "Health :" + "Fat :"
        kamera.addChild(BestPlayerLabel)
        print("bestplayer label added")
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
        distances.removeAll()
        distancesC.removeAll()
        distancesS.removeAll()
        foods.removeAll()
        stones.removeAll()
        maxAge = [Int]()
        maxAgeF = [Int]()
        maxAgeFposition = CGPoint()
        lastMaxAge = Genome(genomeInputs: 1, genomeOutputs: 1)
        bestLastMaxAge = Int()
        drawnNodes = [SKNode]()
        oldestCreature = [Any]()
        bestAge = Int()
        creaturesNumber = [Int]()
        creaturesNumber.append(0)
        creaturesNumber.append(0)
        print("cleared all arrays")
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
            distancesC.append(9999)
            distancesS.append(9999)
            taziskox.append(0)
            taziskoy.append(0)
        }
        print("filled arrays")
        if new {
            //population = prefs.population
            //lunch = prefs.foods
            //soil = prefs.stones
        }
        
        for _ in 0...lunch {
            distances.append(9999.0)
        }
        
        for number in 0...lunch {
            foods.append(addFood())
            foods[number].name = "Food" + String(number)
            addChild(foods[number])
        }
        print("added food")
        for number in 0...soil {
            stones.append(addStones())
            addChild(stones[number])
        }
        print("added stones")
        creatures.removeAll()
        innovationHistory.removeAll()
        if new {
            print("new")
            for number in 0...population {
                print("adding creature ", number)
                creatures.append(addCreature())
                if innovationHistory.isEmpty {
                    for i in 0..<creatures[number].brain.connections.count {
                        innovationHistory.append(creatures[number].brain.connections[i])
                    }
                }
                creatures[number].name = "Creature" + String(number)
                addChild(creatures[number])
            }
        } else {
            print("not new")
            for i in 0..<nextGeneration.count {
                let rand = arc4random()%UInt32(29)
                if rand < 2 {
                    creatures.append(addCreature())
                } else {
                    creatures.append(addCreatureWithWeights(Brain: nextGeneration[i].brain, Diet: nextGeneration[i].diet, Div_1: nextGeneration[i].div_1, Div_2: nextGeneration[i].div_2))
                }
                creatures[i].name = "Creature" + String(i)
                addChild(creatures[i])
            }
        }
        print("added creatures")
        dead = 0
        time = 0
        born = 0
        excessEnergy = 0.0
        print("zeroed parameters")
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addCreature() -> Player {
        
        // Create sprite
        let creature = Player(imageNamed: "Normal")
        // Determine where to spawn the monster along the Y and X axis
        let actualY = random(min: 10, max: CGFloat(Swidth - 10))
        let actualX = random(min: 10, max: CGFloat(Sheight - 10))
        /*if r < 0.5 {
         r = 0
         } else {r = 1}*/
        //let r = CGFloat.random(in: 0 ..< 1)
        creature.diet = 0.5
        creature.div_1 = 1
        creature.div_2 = 2
        creature.speedBonus = CGFloat(creature.div_1)
        creature.attackBonus = creature.div_2 - creature.div_1
        creature.defenseBonus = 3 - creature.div_2
        // Position the monster
        creature.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        creature.color = SKColor.yellow
        creature.colorBlendFactor = 1
        creature.size = CGSize(width: 8,height: 8)
        creature.blendMode = .replace
        //Eyes
        creature.addEyes()
        //creature.addSignals()
        // Collision
        creature.physicsBody = SKPhysicsBody(circleOfRadius: max(creature.size.width / 2,
                                                                 creature.size.height / 2))
        creature.physicsBody?.affectedByGravity = false
        creature.physicsBody?.isDynamic = true
        creature.physicsBody?.categoryBitMask = ColliderType.Creature
        creature.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.friction = 9.0
        creature.physicsBody?.linearDamping = 3.0
        
        //Mutate
        /*
         creature.brain.addConnection(from: 8, to: 11, innovationHistory:&innovationHistory)
         creature.brain.connections[creature.brain.connections.count-1].weight = -1
         creature.brain.addConnection(from: 8, to: 12, innovationHistory:&innovationHistory)
         creature.brain.connections[creature.brain.connections.count-1].weight = 1
         for _ in 0...19 {
         let nodeFrom = Int.random(in: 1 ... creature.brain.nodes.count)
         let nodeTo = Int.random(in: 1 ... creature.brain.nodes.count)
         creature.brain.addConnection(from: nodeFrom, to: nodeTo, innovationHistory:&innovationHistory)
         }
         */
        
        creature.brain.placeNodes()
        
        // Add the monster to the scene
        return creature
    }
    
    func addCreatureWithWeights(Brain: Genome, Diet: CGFloat, Div_1: Double, Div_2: Double) -> Player {
        // Create sprite
        let creature = Player(imageNamed: "Normal")
        // Determine where to spawn the monster along the Y and X axis
        let actualY = random(min: 10, max: CGFloat(Swidth - 10))
        let actualX = random(min: 10, max: CGFloat(Sheight - 10))
        //Mutate Diet
        var rand = arc4random()%UInt32(5)
        if rand == 1 {
            let r = CGFloat.random(in: -1 ... 1)
            if Diet + r/10 > 1 || Diet + r/10 < 0 {
                creature.diet = Diet - r/10
            } else {
                creature.diet = Diet + r/10
            }
            print("mutoval diet na:",r)
        } else {
            creature.diet = Diet
        }
        //Mutate bonuses
        rand = arc4random()%UInt32(3)
        if rand == 1 {
            let r1 = Double.random(in: -3 ... 3)
            let r2 = Double.random(in: -3 ... 3)
            if Div_1 + r1/10 >= 3 || Div_1 + r1/10 <= 0 {
                creature.div_1 = Div_1 - r1/10
            } else {
                creature.div_1 = Div_1 + r1/10
            }
            if Div_2 + r2/10 >= 3 || Div_2 + r2/10 <= 0 {
                creature.div_2 = Div_2 - r2/10
            } else {
                creature.div_2 = Div_2 + r2/10
            }
            if creature.div_1 > creature.div_2 {
                swap(&creature.div_1, &creature.div_2)
            }
        } else {
            creature.div_1 = Div_1
            creature.div_2 = Div_2
        }
        creature.speedBonus = CGFloat(creature.div_1)
        creature.attackBonus = creature.div_2 - creature.div_1
        creature.defenseBonus = 3 - creature.div_2
        // Position the monster
        creature.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        creature.color = SKColor.yellow
        creature.colorBlendFactor = 1
        creature.size = CGSize(width: 8,height: 8)
        creature.blendMode = .replace
        //Eyes
        creature.addEyes()
        //creature.addSignals()
        // Collision
        creature.physicsBody = SKPhysicsBody(circleOfRadius: max(creature.size.width / 2,
                                                                 creature.size.height / 2))
        creature.physicsBody?.affectedByGravity = false
        creature.physicsBody?.isDynamic = true
        creature.physicsBody?.categoryBitMask = ColliderType.Creature
        creature.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Creature
        creature.physicsBody?.friction = 9.0
        creature.physicsBody?.linearDamping = 3.0
        //Maybe mutate, maybe not
        creature.brain.connections = Brain.connections
        creature.brain.nodes = Brain.nodes
        creature.brain.inputs = Brain.inputs
        creature.brain.outputs = Brain.outputs
        creature.brain.mutate(innovationHistory: &innovationHistory)
        let rand1 = Double.random(in: 0.9 ... 1)
        if rand1 < 0.8 { // 80% of the time mutate weights
            //for _ in 0..<creature.brain.connections.count {
            creature.brain.mutateWeight()
            //}
        }
        /*let rand2 = Double.random(in: 0 ... 1)
         if rand2 < 0.5 { // 50% of the time mutate weights
         //for _ in 0..<creature.brain.connections.count {
         creature.brain.mutateWeight0()
         //}
         }*/
        //10% of the time add a node
        //for _ in 0...5 {
        let rand3 = Double.random(in: 0.9 ... 1)
        if rand3 < 0.1 {
            creature.brain.addNode(innovationHistory:&innovationHistory)
            if activationSwitch {
                creature.brain.nodes[creature.brain.nodes.count-1].activation = Int.random(in: 0 ... 3)
                //print("new node activated by: ", creature.brain.nodes[creature.brain.nodes.count-1].activation)
            }
            //}
        }
        //5% of the time add a new connection
        let rand4 = Double.random(in: 0.9 ... 1)
        if rand4 < 0.15 {
            //print("chce poridať novú connection")
            //toto vyberie náhodný hidden node
            /*var hiddenNodes = 0
             for i in 0..<creature.brain.nodes.count {
             if creature.brain.nodes[i].type == 1 {
             hiddenNodes += 1
             }
             }
             //print("našlo sa ",hiddenNodes," hidden nodes")
             if hiddenNodes > 0 {
             var nodeFrom = 0
             var nodeTo = 0
             repeat {
             nodeFrom = Int.random(in: 1 ... creature.brain.nodes.count)
             nodeTo = Int.random(in: 1 ... creature.brain.nodes.count)
             } while !(creature.brain.nodes[nodeFrom-1].type == 1 || creature.brain.nodes[nodeTo-1].type == 1)
             //print("nodeFrom: ",nodeFrom," nodeTo:", nodeTo)
             creature.brain.addConnection(from: nodeFrom, to: nodeTo, innovationHistory:&innovationHistory)
             //print(creature.brain.connections)
             } else {*/
            var nodeFrom = 0
            var nodeTo = 0
            var tries = 0
            repeat {
                nodeFrom = Int.random(in: 1 ... creature.brain.nodes.count)
                nodeTo = Int.random(in: 1 ... creature.brain.nodes.count)
                tries += 1
            } while (creature.brain.nodes[nodeFrom-1].type == 2 ||  creature.brain.nodes[nodeTo-1].type == 0) && (tries < 30)
            //print("nodeFrom: ",nodeFrom," nodeTo:", nodeTo, " tries: ", tries)
            creature.brain.addConnection(from: nodeFrom, to: nodeTo, innovationHistory:&innovationHistory)
            //print(creature.brain.connections)
            //}
        }
        
        creature.brain.placeNodes()
        
        // Add the monster to the scene
        return creature
    }
    
    func addFood() -> Food {
        
        // Create sprite
        let food = Food(rectOf: CGSize.init(width: 4, height: 4))
        
        // Determine where to spawn the food along the Y and X axis
        let random = GKRandomSource()
        let randGaussY = GKGaussianDistribution(randomSource: random, lowestValue: -290, highestValue: (Swidth + 290))
        let randGaussX = GKGaussianDistribution(randomSource: random, lowestValue: -290, highestValue: (Sheight + 290))
        //let actualY = random(min: 10, max: CGFloat(Swidth - 10))
        //let actualX = random(min: 10, max: CGFloat(Sheight - 10))
        let actualY = randGaussY.nextInt()
        let actualX = randGaussX.nextInt()
        
        // Position the food
        food.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        food.fillColor = SKColor.green
        food.lineWidth = 0
        food.name = "Food"
        food.blendMode = .replace
        food.isAntialiased = false
        
        // Collision
        food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4,height: 4))
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = true
        food.physicsBody?.categoryBitMask = ColliderType.Food
        food.physicsBody?.friction = 9.0
        food.physicsBody?.linearDamping = 3.0
        
        // Add the food to the scene
        return food
    }
    
    func addStones() -> Stone {
        
        // Create sprite
        let stone = Stone(rectOf: CGSize.init(width: 12, height: 12))
        
        // Determine where to spawn the food along the Y and X axis
        let actualY = random(min: 10, max: CGFloat(Swidth - 10))
        let actualX = random(min: 10, max: CGFloat(Sheight - 10))
        
        // Position the food
        stone.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
        stone.fillColor = SKColor.brown
        stone.lineWidth = 0
        stone.name = "Stone"
        stone.blendMode = .replace
        stone.isAntialiased = false
        
        // Collision
        stone.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 6,height: 6))
        stone.physicsBody?.affectedByGravity = false
        stone.physicsBody?.isDynamic = true
        stone.physicsBody?.categoryBitMask = ColliderType.Stone
        stone.physicsBody?.friction = 19.0
        stone.physicsBody?.linearDamping = 13.0
        
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
            //print("CONTACT", numero)
            let abcd34 = (secondBody.node!.name)!
            let numero2 = (abcd34.dropFirst(4) as NSString).integerValue
            if creatures[numero].alive {
                creatures[numero].contactsf.insert(numero2)
            }
            /*creatures[numero].energy += Double(100 * creatures[numero].diet)
             foods[numero2].energy -= Double(100 * creatures[numero].diet)
             //foods[numero2].position.x = random(min: 5, max: 9795)
             //foods[numero2].position.y = random(min: 5, max: 7795)
             //secondBody.node?.removeFromParent()
             if foods[numero2].energy < 0.0 {
             let movex = SKAction.moveTo(x: random(min: 10, max: CGFloat(Swidth - 10)), duration: 0.0)
             let movey = SKAction.moveTo(y: random(min: 10, max: CGFloat(Sheight - 10)), duration: 0.0)
             secondBody.node?.run(movex)
             secondBody.node?.run(movey)
             foods[numero2].energy = 300.0
             }*/
        }
        
        if (firstBody.node?.name?.hasPrefix("Creature"))! && (secondBody.node?.name?.hasPrefix("Creature"))! {
            let abcd12 = (firstBody.node!.name)!
            let numero = (abcd12.dropFirst(8) as NSString).integerValue
            let abcd34 = (secondBody.node!.name)!
            let numero2 = (abcd34.dropFirst(8) as NSString).integerValue
            print("TOUCH", numero , numero2)
            if creatures[numero].alive && creatures[numero2].alive {
                if creatures[numero].hate > 0.5 && creatures[numero2].hate <= 0.5 {
                    print(numero , " HATES " , numero2)
                    print(creatures[numero].diet, creatures[numero].hate, creatures[numero].attackBonus, creatures[numero2].defenseBonus)
                    let damage = Double(300 * creatures[numero].diet) * creatures[numero].hate * creatures[numero].attackBonus / creatures[numero2].defenseBonus
                    if creatures[numero].age > 1000 {
                        creatures[numero].fat += damage
                    } else {
                        creatures[numero].maxHealth += damage
                        creatures[numero].health += damage
                    }
                    if creatures[numero2].age > 1000 {
                        creatures[numero2].fat -= damage
                    } else {
                        creatures[numero2].maxHealth -= damage
                        creatures[numero2].health -= damage
                    }
                    print(numero, " gained: " , damage)
                }
                if creatures[numero].love > 0.5 {
                    //do love here
                    /*if creatures[numero].energy > creatures[numero2].energy && creatures[numero].age > 1000 && !creatures[numero].pregnant && creatures[numero].energy > 1000 {
                     creatures[numero].pregnant = true
                     print("pregnant")
                     
                     creatures[numero].babyBrain = doLove(Brain1: creatures[numero].brain, Brain2: creatures[numero2].brain)
                     
                     creatures[numero].babyDiet = creatures[numero].diet
                     }*/
                    if creatures[numero].health+creatures[numero].fat > creatures[numero2].health+creatures[numero2].fat && creatures[numero].age > 1000 && !creatures[numero].pregnant && creatures[numero].health+creatures[numero].fat > 1000 && creatures[numero2].age > 1000{
                        creatures[numero].pregnant = true
                        print("pregnant")
                        creatures[numero].babyBrain = creatures[numero].brain.crossover(parent2:creatures[numero2].brain)
                        //creatures[numero].babyBrain = doLove(Brain1: creatures[numero].brain, Brain2: creatures[numero2].brain)
                        
                        creatures[numero].babyDiet = creatures[numero].diet
                    }
                }
                if creatures[numero2].hate > 0.5 && creatures[numero].hate <= 0.5 {
                    print(numero2 , " HATES " , numero)
                    print(creatures[numero2].diet, creatures[numero2].hate, creatures[numero2].attackBonus, creatures[numero].defenseBonus)
                    let damage2 = Double(300 * creatures[numero2].diet) * creatures[numero2].hate * creatures[numero2].attackBonus / creatures[numero].defenseBonus
                    if creatures[numero2].age > 1000 {
                        creatures[numero2].fat += damage2
                    } else {
                        creatures[numero2].maxHealth += damage2
                        creatures[numero2].health += damage2
                    }
                    if creatures[numero].age > 1000 {
                        creatures[numero].fat -= damage2
                    } else {
                        creatures[numero].maxHealth -= damage2
                        creatures[numero].health -= damage2
                    }
                    print(numero2, " gained: " , damage2)
                }
                if creatures[numero2].love > 0.5 {
                    //do love here
                    /*if creatures[numero2].energy > creatures[numero].energy && creatures[numero2].age > 1000 && !creatures[numero2].pregnant && creatures[numero2].energy > 1000 {
                     creatures[numero2].pregnant = true
                     print("pregnant")
                     
                     creatures[numero2].babyBrain = doLove(Brain1: creatures[numero2].brain, Brain2: creatures[numero].brain)
                     
                     creatures[numero2].babyDiet = creatures[numero2].diet
                     }*/
                    if creatures[numero2].health+creatures[numero2].fat > creatures[numero].health+creatures[numero].fat && creatures[numero2].age > 1000 && !creatures[numero2].pregnant && creatures[numero2].health+creatures[numero2].fat > 1000 && creatures[numero].age > 1000{
                        creatures[numero2].pregnant = true
                        print("pregnant")
                        creatures[numero2].babyBrain = creatures[numero2].brain.crossover(parent2:creatures[numero].brain)
                        //creatures[numero2].babyBrain = doLove(Brain1: creatures[numero2].brain, Brain2: creatures[numero].brain)
                        
                        creatures[numero2].babyDiet = creatures[numero2].diet
                    }
                }
                if creatures[numero2].hate > 0.5 && creatures[numero].hate > 0.5 {
                    print(numero2 , " & " , numero , " hate each other")
                    let damage = Double(300 * creatures[numero].diet) * creatures[numero].hate * creatures[numero].attackBonus / creatures[numero2].defenseBonus
                    let damage2 = Double(300 * creatures[numero2].diet) * creatures[numero2].hate * creatures[numero2].attackBonus / creatures[numero].defenseBonus
                    if creatures[numero].age > 1000 {
                        creatures[numero].fat += damage
                        creatures[numero].fat -= damage2
                    } else {
                        creatures[numero].maxHealth += damage
                        creatures[numero].health += damage
                        creatures[numero].maxHealth -= damage2
                        creatures[numero].health -= damage2
                    }
                    if creatures[numero2].age > 1000 {
                        creatures[numero2].fat += damage2
                        creatures[numero2].fat -= damage
                    } else {
                        creatures[numero2].maxHealth += damage2
                        creatures[numero2].health += damage2
                        creatures[numero2].maxHealth -= damage
                        creatures[numero2].health -= damage
                    }
                    print(numero2 , " diet: " , creatures[numero2].diet)
                    print(numero2, " fat change: " , damage2 - damage)
                    print(numero , " diet: " , creatures[numero].diet)
                    print(numero, " fat change: " , damage - damage2)
                }
            }
        }
    }
    
    func doLove(Brain1: Genome, Brain2: Genome) -> Genome {
        let brain1 = Brain1
        let brain2 = Brain2
        var babyBrain = brain1
        for i in 0..<babyBrain.connections.count {
            for j in 0..<brain2.connections.count {
                if babyBrain.connections[i].innovation == brain2.connections[j].innovation {
                    let r = Int.random(in: 0 ... 1)
                    if r == 0 {
                        babyBrain.connections[i] = brain2.connections[j]
                        print("Konekcia ",i," zdedená od slabšieho")
                        //ak nemá node, pridaj node
                        //najprv from
                        var found = false
                        for n in 0..<babyBrain.nodes.count {
                            if brain2.connections[j].from-1 == babyBrain.nodes[n].id {
                                found = true
                            }
                        }
                        if !found {
                            babyBrain.nodes.append(brain2.nodes[brain2.connections[j].from-1])
                        }
                        //potom to
                        found = false
                        for n in 0..<babyBrain.nodes.count {
                            if brain2.connections[j].to-1 == babyBrain.nodes[n].id {
                                found = true
                            }
                        }
                        if !found {
                            babyBrain.nodes.append(brain2.nodes[brain2.connections[j].to-1])
                        }
                    } else {
                        print("Konekcia ",i," zdedená od silnejšieho")
                    }
                }
            }
        }
        babyBrain = brain1.crossover(parent2: brain2)
        return babyBrain
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
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
            let abcd34 = (secondBody.node!.name)!
            let numero2 = (abcd34.dropFirst(4) as NSString).integerValue
            //print("STOPCONTACT", numero , numero2)
            creatures[numero].contactsf.remove(numero2)
        }
    }
    
    func draw_population(numbers: [Int]) {
        let halfWidth = Int(-self.size.width/2)
        let halfHeight = Int(-self.size.height/2)
        let odpocet = numbers.max()!-numbers.min()!
        //print("rozdiel max a min: ", numbers.max()! , " - " , numbers.min()! , " = " , odpocet)
        let zlomok = 100/(Double(odpocet+1))
        let zlomokW = 300/Double(numbers.count)
        //print("zlomok: 200 / (", odpocet , " + 1) = " , zlomok)
        for i in 1..<numbers.count {
            let vyskaIn = Double(numbers[i-1]-numbers.min()!)
            let vyskaOut = Double(numbers[i]-numbers.min()!)
            let xIn = halfWidth+330+Int(zlomokW*Double((i-1)))
            let yIn = halfHeight+30+Int(zlomok*vyskaIn)
            //print("xIn = ", xIn, ", yIn = ", yIn)
            let xOut = halfWidth+330+Int(zlomokW*Double(i))
            let yOut = halfHeight+30+Int(zlomok*vyskaOut)
            //print("xOut = ", xOut, ", yOut = ", yOut)
            let line = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: CGPoint(x: xIn, y: yIn))
            pathToDraw.addLine(to: CGPoint(x: xOut, y: yOut))
            line.path = pathToDraw
            line.lineWidth = 1
            line.strokeColor = SKColor(red: 0,green: 0, blue: 1 , alpha:1)
            line.isAntialiased = false
            drawnNodes.append(line)
            kamera.addChild(line)
        }
    }
    
    func draw_brain (creature: Player) {
        let halfWidth = Int(-self.size.width/2)
        let halfHeight = Int(-self.size.height/2)
        //draw nodes
        for i in 0..<creature.brain.nodes.count {
            let node = SKShapeNode(rectOf: CGSize.init(width: 7, height: 7))
            //let x = Int(805+390*creature.brain.nodes[i].x)
            //let y = Int(100+600*creature.brain.nodes[i].y)
            let x = halfWidth+30+Int(190*creature.brain.nodes[i].x)
            let y = -30+Int(-Double(halfHeight)*creature.brain.nodes[i].y)
            node.position = CGPoint(x: x, y: y)
            node.fillColor = SKColor(red: CGFloat(-(creature.brain.nodes[i].outputValue) + 1),green: CGFloat(creature.brain.nodes[i].outputValue), blue: 0 , alpha:1.0)
            if creature.brain.nodes[i].type == 3 { //if the nodes are inputs
                if creature.brain.nodes[i].outputValue > 0.5 {
                    node.fillColor = SKColor(red: 0, green: 1, blue: 0, alpha: 1)
                } else {
                    node.fillColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1)
                }
                //node.fillColor = SKColor(red: CGFloat(-(creature.brain.nodes[i].outputValue) / 5 ),green: CGFloat((creature.brain.nodes[i].outputValue) / 5), blue: 0 , alpha:1.0)
            }
            if creature.brain.nodes[i].activation == 0 {
                node.lineWidth = 0
            } else if creature.brain.nodes[i].activation == 1 {
                node.lineWidth = 2
                node.strokeColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
            } else if creature.brain.nodes[i].activation == 2 {
                node.lineWidth = 2
                node.strokeColor = SKColor(red: 1, green: 0, blue: 1, alpha: 1)
            } else if creature.brain.nodes[i].activation == 3 {
                node.lineWidth = 2
                node.strokeColor = SKColor(red: 0, green: 0, blue: 1, alpha: 1)
            }
            node.blendMode = .replace
            node.isAntialiased = false
            drawnNodes.append(node)
            kamera.addChild(node)
        }
        //draw connections
        for i in 0..<creature.brain.connections.count {
            if creature.brain.connections[i].enabled {
                let xIn = halfWidth+30+Int(190*creature.brain.nodes[creature.brain.connections[i].from-1].x)
                let yIn = -30+Int(-Double(halfHeight)*creature.brain.nodes[creature.brain.connections[i].from-1].y)
                let xOut = halfWidth+30+Int(190*creature.brain.nodes[creature.brain.connections[i].to-1].x)
                let yOut = -30+Int(-Double(halfHeight)*creature.brain.nodes[creature.brain.connections[i].to-1].y)
                let c = creature.brain.connections[i].weight
                let line = SKShapeNode()
                let pathToDraw = CGMutablePath()
                pathToDraw.move(to: CGPoint(x: xIn, y: yIn))
                pathToDraw.addLine(to: CGPoint(x: xOut, y: yOut))
                line.path = pathToDraw
                if c < 0 {
                    line.lineWidth = CGFloat(-c)*3
                } else {
                    line.lineWidth = CGFloat(c)*3
                }
                let alphaLine = abs(creature.brain.connections[i].weight) * abs(creature.brain.nodes[creature.brain.connections[i].from-1].outputValue)
                line.strokeColor = SKColor(red: CGFloat((c-1)*(-0.5)),green: CGFloat((c+1)*0.5), blue: 0 , alpha:CGFloat(alphaLine))
                line.isAntialiased = false
                drawnNodes.append(line)
                kamera.addChild(line)
            }
        }
        BestPlayerLabel.numberOfLines = 0
        BestPlayerLabel.text = "Health :" + String(creature.health)
        BestPlayerLabel.text! += "\nFat :" + String(creature.fat)
        BestPlayerLabel.text! += "\nDiet :" + String(Double(creature.diet))
        BestPlayerLabel.text! += "\nSpeed,Attack,Defense :" + String((1000*Double(creature.speedBonus)).rounded()/1000)
        BestPlayerLabel.text! += " " + String((1000*creature.attackBonus).rounded()/1000)
        BestPlayerLabel.text! += " " + String((1000*creature.defenseBonus).rounded()/1000)
        /*//draw initial connections
         for i in 0..<creature.brain.inputs*creature.brain.outputs {
         if creature.brain.connections[i].enabled {
         let c = creature.brain.connections[i].weight
         let line = SKShapeNode()
         let pathToDraw = CGMutablePath()
         pathToDraw.move(to: CGPoint(x: 805.0, y: Double(700/creature.brain.inputs * (creature.brain.connections[i].from-1) + 100)))
         pathToDraw.addLine(to: CGPoint(x: 995.0, y: Double(700/creature.brain.outputs * (creature.brain.connections[i].to-creature.brain.inputs-1) + 100)))
         line.path = pathToDraw
         if c < 0 {
         line.lineWidth = CGFloat(-c)
         } else {
         line.lineWidth = CGFloat(c)
         }
         line.strokeColor = SKColor(red: CGFloat((c-1)*(-0.5)),green: CGFloat((c+1)*0.5), blue: 0 , alpha:1.0)
         drawnNodes.append(line)
         addChild(line)
         }
         }*/
        /*
         //draw layer_two_weights
         for a in 0..<creature.brain.number_middle2_nodes {
         for b in 0..<creature.brain.number_middle_nodes{
         let c = creature.brain.layer_two_weights[b*creature.brain.number_middle2_nodes+a]
         let line = SKShapeNode()
         let pathToDraw = CGMutablePath()
         pathToDraw.move(to: CGPoint(x: 931.0, y: Double(700/creature.brain.middle2_nodes.count * a + 100)))
         pathToDraw.addLine(to: CGPoint(x: 868.0, y: Double(700/creature.brain.middle_nodes.count * b + 100)))
         line.path = pathToDraw
         if c < 0 {
         line.lineWidth = CGFloat(-c)
         } else {
         line.lineWidth = CGFloat(c)
         }
         line.strokeColor = SKColor(red: CGFloat(-(c) + 1),green: CGFloat(c), blue: 0 , alpha:1.0)
         drawnNodes.append(line)
         addChild(line)
         }
         }
         
         //draw layer_three_weights
         for a in 0..<creature.brain.number_output_nodes {
         for b in 0..<creature.brain.number_middle2_nodes{
         let c = creature.brain.layer_three_weights[b*creature.brain.number_output_nodes+a]
         let line = SKShapeNode()
         let pathToDraw = CGMutablePath()
         pathToDraw.move(to: CGPoint(x: 995.0, y: Double(700/creature.brain.output_nodes.count * a + 100)))
         pathToDraw.addLine(to: CGPoint(x: 931.0, y: Double(700/creature.brain.middle2_nodes.count * b + 100)))
         line.path = pathToDraw
         if c < 0 {
         line.lineWidth = CGFloat(-c)
         } else {
         line.lineWidth = CGFloat(c)
         }
         line.strokeColor = SKColor(red: CGFloat(-(c) + 1),green: CGFloat(c), blue: 0 , alpha:1.0)
         drawnNodes.append(line)
         addChild(line)
         }
         }*/
        
        
    }
    
    func umreli() -> Bool {
        for i in 0..<creatures.count {
            if creatures[i].alive {
                return false
            }
        }
        return true
    }
    
    func nextGenParent(randAgesSum: Int , tresholds: [Int]) -> Int {
        for i in 0..<tresholds.count {
            if randAgesSum <= tresholds[i] {
                return i
            }
        }
        return 99990
    }
    
    func naturalSelection() {
        // self.batchNo = 0;
        let previousBest = deadCreatures[0]
        speciate() //seperate the self.players varo self.species
        print("after speciation species:   ", self.species.count)
        calculateFitness() //calculate the fitness of each player
        sortSpecies() //sort the self.species to be ranked in fitness order, best first
        print("after sorting species:   ", self.species.count)
        killEmptySpecies()
        print("after killing empty species:   ", self.species.count)
        cullSpecies() //kill off the bottom half of each self.species
        print("after culling species:   ", self.species.count)
        oblivionate()
        //self.setBestPlayer() //save the best player of thisself.gen
        if species.count > 1 {self.killStaleSpecies()} //remove self.species which haven't improved in the last 15(ish)self.generations
        print("after killing stale species:   ", self.species.count)
        print("DeadCreatures before oblivionating:   ", deadCreatures.count)
        oblivionate() // vyradí do zatratenia mrtve potvorky, ktoré nie sú v species
        print("DeadCreatures after oblivionating:   ", deadCreatures.count)
        self.killBadSpecies() //kill self.species which are so bad that they cant reproduce
        print("after killing bad species:   ", self.species.count)
        oblivionate()
        
        print("  Number of mutations  ", self.innovationHistory.count, "  species:   ", self.species.count, "  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    }
    
    //seperate self.players into self.species based on how similar they are to the leaders of each self.species in the previousself.gen
    func speciate() {
        for s in species { //empty self.species
            s.players = []
        }
        for i in 0..<deadCreatures.count { //for each player
            var speciesFound = false
            for s in 0..<self.species.count { //for each self.species
                if (self.species[s].sameSpecies(g: deadCreatures[i].brain)) { //if the player is similar enough to be considered in the same self.species
                    self.species[s].addToSpecies(p: deadCreatures[i]) //add it to the self.species
                    speciesFound = true
                    break
                }
            }
            if !speciesFound { //if no self.species was similar enough then add a new self.species with this as its champion
                self.species.append(Species(p: deadCreatures[i]))
            }
        }
    }
    
    //sorts the players within a self.species and the self.species by their fitnesses
    func sortSpecies() {
        //sort the players within a self.species
        for s in species {
            s.sortSpecies()
        }
        
        //sort the self.species by the fitness of its best player
        //using selection sort like a loser
        var temp = [Species]() //new ArrayList<Species>();
        while !self.species.isEmpty {
            var max = 0
            var maxIndex = 0
            for j in 0..<self.species.count {
                if (self.species[j].bestFitness > max) {
                    max = self.species[j].bestFitness
                    maxIndex = j
                }
            }
            temp.append(self.species[maxIndex])
            self.species.remove(at: maxIndex)
        }
        self.species = temp
    }
    
    //kill the bottom half of each self.species
    func cullSpecies() {
        for s in self.species {
            s.cull(); //kill bottom half
            s.fitnessSharing(); //also while we're at it lets do fitness sharing
            s.setAverage(); //reset averages because they will have changed
        }
    }
    
    //kills all self.species which haven't improved in 15self.generations
    func killStaleSpecies() {
        var temp = [Species]()
        temp.append(self.species[0])
        temp.append(self.species[1])
        for i in 2..<self.species.count {
            if self.species[i].staleness < 15 {
                temp.append(self.species[i])
            }
        }
        self.species = temp
    }
    
    //if a self.species sucks so much that it wont even be allocated 1 child for the nextself.generation then kill it now
    func killBadSpecies() {
        let averageSum = self.getAvgFitnessSum()
        print("average fitness sum is ", averageSum)
        var temp = [Species]()
        temp.append(self.species[0])
        for i in 1..<self.species.count {
            print(self.species[i].averageFitness," ", averageSum , " ", deadCreatures.count)
            if Double(self.species[i].averageFitness) / Double(averageSum) * Double(deadCreatures.count) >= 1 { //if wont be given a single child
                // self.species.remove(i); //sad
                temp.append(self.species[i])
            }
        }
        self.species = temp
    }
    
    //returns the sum of each self.species average fitness
    func getAvgFitnessSum()->Int {
        var averageSum = 0
        for s in self.species {
            averageSum += s.averageFitness
        }
        return averageSum;
    }
    
    //calculates the fitness of all of the players
    func calculateFitness() {
        for i in 0..<deadCreatures.count {
            deadCreatures[i].calculateFitness()
        }
        for s in species {
            for p in s.players {
                p.calculateFitness()
            }
        }
    }
    
    func killEmptySpecies() {
        var temp = [Species]()
        for i in 0..<self.species.count {
            if self.species[i].players.count >= 1 { 
                temp.append(self.species[i])
            }
        }
        self.species = temp
    }
    
    func oblivionate() {
        var temp = [Player]()
        for d in deadCreatures {
            for s in species {
                for p in s.players
                {
                    if p.brain.connections == d.brain.connections {
                        temp.append(d)
                        break
                    }
                }
            }
        }
        deadCreatures = temp
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

extension GameScene {
    
    // MARK: - Preferences
    
    func setupPrefs() {
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        let observer = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) {
            (notification) in self.updateFromPrefs()
        }
        for observer in notifObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        notifObservers.removeAll()
        notifObservers.append(observer)
    }
    
    func updateFromPrefs() {
        print("prefferences changed to: ",self.prefs.population, self.prefs.foods, self.prefs.stones )
        self.population = self.prefs.population
        self.lunch = self.prefs.foods
        self.soil = self.prefs.stones
        self.restart(nextGeneration: [], new: true)
    }
}
