//
//  Genome.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 15/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
import GameplayKit

public class Genome {
    
    var connections = [Connection]()
    var nodes = [Node]()
    var inputs = Int()
    var outputs = Int()
    
    init (genomeInputs:Int, genomeOutputs:Int){
        inputs = genomeInputs
        outputs = genomeOutputs
        
        //add input and output nodes
        for i in 1...inputs {
            nodes.append(Node(id: i, type: 0))
            nodes[nodes.count-1].x = 0
            //nodes[nodes.count-1].activation = 1
            if inputs > 1 {
                let NodesDist = 1/Double(inputs-1)
                nodes[nodes.count-1].y = NodesDist*Double(i-1)
            }
        }
        for o in inputs+1...inputs+outputs {
            nodes.append(Node(id: o, type: 2))
            nodes[nodes.count-1].x = 1
            //nodes[nodes.count-1].activation = 1
            if outputs > 1 {
                let NodesDist = 1/Double(outputs-1)
                nodes[nodes.count-1].y = NodesDist*Double(o-1-inputs)
            }
        }
        //add initial connections
        var inno = 1
        for i in 1...inputs {
            for o in 1...outputs {
                let rand = Int.random(in: 1...inputs*outputs)
                if i == 0 {
                    let newConnection = Connection(innovation: inno, to: o+inputs, from: i, weight: 0.0 , enabled: true)
                    connections.append(newConnection)
                    inno += 1
                } else {
                    let newConnection = Connection(innovation: inno, to: o+inputs, from: i, weight: Double.random(in: -1...1), enabled: true) // Double.random(in: -1...1), enabled: true)
                    connections.append(newConnection)
                    inno += 1
                }
                
            }
        }
    }
    
    func forwardPropagate(inputs: [Double]) -> [Double] {
        let sensors = inputs
        //print("vstupy", inputs)
        
        for n in 0..<self.nodes.count {
            self.nodes[n].inputSum = 0
        }
        
        for i in 0..<self.inputs {
            self.nodes[i].outputValue = 1 / (1 + exp(-0.5*sensors[i]))
            /*self.nodes[i].buffer += sensors[i]
            if self.nodes[i].buffer > 0.21429 {
                self.nodes[i].buffer = -0.285714 * 2
                self.nodes[i].outputValue = 1
            } else {
                self.nodes[i].outputValue = 0
            }
            self.nodes[i].buffer /= 1.05*/
        }
        
        for c in 0..<connections.count {
            if connections[c].enabled {
                nodes[connections[c].to-1].inputSum += (nodes[connections[c].from-1].outputValue * connections[c].weight)
            }
        }
        
        for n in self.inputs..<self.nodes.count {
            if self.nodes[n].activation == 0 {
                //Sigmoid activation
                self.nodes[n].outputValue = 1 / (1 + exp(-0.5*self.nodes[n].inputSum))
            } else if self.nodes[n].activation == 1{
                //ReLu Activation
                if self.nodes[n].inputSum < 0 {
                    self.nodes[n].outputValue = 0
                } else {
                    self.nodes[n].outputValue = self.nodes[n].inputSum
                }
            } else if self.nodes[n].activation == 2{
                //STEP activation
                if self.nodes[n].inputSum <= 0 {
                    self.nodes[n].outputValue = 0
                } else {
                    self.nodes[n].outputValue = 1
                }
            } else if self.nodes[n].activation == 3{
                //Gaussian activation
                self.nodes[n].outputValue = exp(-1*pow(self.nodes[n].inputSum, 2))
            }
            /*self.nodes[n].buffer += self.nodes[n].inputSum
            if self.nodes[n].buffer > 0.21429 {
                self.nodes[n].buffer = -0.285714
                self.nodes[n].outputValue = 1
            } else {
                self.nodes[n].outputValue = 0
            }
            self.nodes[n].buffer /= 1.5*/
        }
        
        var vondaj = [Double]()
        for o in self.inputs..<self.inputs+self.outputs {
            vondaj.append(self.nodes[o].outputValue)
        }
        //print("vystupy", vondaj)
        return vondaj
    }
    
    func placeNodes() {
        if connections.count > 0 {
            //Found at least one connection"
            for n in 0..<nodes.count {
                nodes[n].xSum = 0.0
                nodes[n].ySum = 0.0
                nodes[n].inx.removeAll()
                nodes[n].iny.removeAll()
                nodes[n].ConnectionNo = 0
            }
            //removed xSum & ySum
            for c in 0..<connections.count {
                if connections[c].enabled {
                if nodes[connections[c].to-1].type == 1 {
                    //nodes[connections[c].to-1].xSum += nodes[connections[c].from-1].x
                    nodes[connections[c].to-1].inx.insert(nodes[connections[c].from-1].x)
                    //nodes[connections[c].to-1].ySum += nodes[connections[c].from-1].y
                    nodes[connections[c].to-1].iny.insert(nodes[connections[c].from-1].y)
                    //nodes[connections[c].to-1].ConnectionNo += 1
                }
                if nodes[connections[c].from-1].type == 1 {
                    //nodes[connections[c].from-1].xSum += nodes[connections[c].to-1].x
                    nodes[connections[c].from-1].inx.insert(nodes[connections[c].to-1].x)
                    //nodes[connections[c].from-1].ySum += nodes[connections[c].to-1].y
                    nodes[connections[c].from-1].iny.insert(nodes[connections[c].to-1].y)
                    //nodes[connections[c].from-1].ConnectionNo += 1
                }
                }
            }
            
            for n in 0..<nodes.count {
                if nodes[n].type == 1 {
                    if nodes[n].inx.count != 0 {
                        let reducedx = nodes[n].inx.reduce(0, +) //sčíta všetky x súradnice príchodzích neurónov
                        nodes[n].x = reducedx/Double(nodes[n].inx.count) //vypočíta a nasadí priemernú x súradnicu
                        //nodes[n].x = nodes[n].xSum/Double(nodes[n].ConnectionNo)//calculateMedian(array: nodes[n].xSum)
                        //print("Node x = ", nodes[n].x)
                    }
                    if nodes[n].iny.count != 0 {
                        let reducedy = nodes[n].iny.reduce(0, +)
                        nodes[n].y = reducedy/Double(nodes[n].iny.count)
                        //nodes[n].y = nodes[n].ySum/Double(nodes[n].ConnectionNo)//calculateMedian(array: nodes[n].ySum)
                    }
                    for m in 0..<nodes.count {
                        let xDist = nodes[n].x - nodes[m].x
                        let yDist = nodes[n].y - nodes[m].y
                        let Dist = sqrt(xDist * xDist + yDist * yDist)
                        if  Dist < 0.07 && m != n {
                            if Dist == 0 {
                                if nodes[n].x >= 1 {
                                    nodes[n].x -= 0.005
                                } else {
                                    nodes[n].x += 0.005 }
                                if nodes[n].y >= 1 {
                                    nodes[n].y -= 0.005
                                } else {
                                    nodes[n].y += 0.005 }
                            } else {
                                nodes[n].x += 0.005*(xDist/Dist)
                                nodes[n].y += 0.005*(yDist/Dist)
                                if nodes[m].type == 1 {
                                    nodes[m].x -= 0.005*(xDist/Dist)
                                    nodes[m].y -= 0.005*(yDist/Dist)
                                    //print("xDist: ", xDist, "yDist: ", yDist, "Dist: ", Dist)
                                    //print("x korekcia o : ",0.005*(xDist/Dist))
                                    //print("y korekcia o : ",0.005*(yDist/Dist))
                                }
                            }
                        }
                    }
                    /*if nodes[n].xSum != 0 {
                        nodes[n].x = nodes[n].xSum/Double(nodes[n].ConnectionNo)//calculateMedian(array: nodes[n].xSum)
                        //print("Node x = ", nodes[n].x)
                    }
                    if nodes[n].ySum != 0 {
                        nodes[n].y = nodes[n].ySum/Double(nodes[n].ConnectionNo)//calculateMedian(array: nodes[n].ySum)
                    }*/
                    if nodes[n].x < 0.07 {
                        nodes[n].x = 0.07
                    } else if nodes[n].x > 0.93 {
                        nodes[n].x = 0.93
                    }
                    if nodes[n].y < 0.07 {
                        nodes[n].y = 0.07
                    } else if nodes[n].y > 0.93 {
                        nodes[n].y = 0.93
                    }
                }
            }
            
        }// else {print("no connections")}
        //print("Done Placing Nodes")
    }
    
    func addConnection(from: Int, to: Int, innovationHistory: inout [Connection]) {
        var node1 = from
        var node2 = to
        let randomWeight = Double.random(in: -1...1)
        
        if node2 == node1 || nodes[node2-1].type == 0 || nodes[node1-1].type == 2 {
            //node1 = Int.random(in: 1...nodes.count)
            //node2 = Int.random(in: 1...nodes.count)
            return
        }
        if nodes[node1-1].type > nodes[node2-1].type {
            swap(&node1, &node2)
        }
        for i in 0..<self.connections.count {
            if self.connections[i].from == node1 && self.connections[i].to  == node2 {
                return
            }
        }
        var newInnovation = true
        var inno = Int()
        for i in 0..<innovationHistory.count {
            if innovationHistory[i].from == node1 && innovationHistory[i].to == node2 {
                inno = innovationHistory[i].innovation
                newInnovation = false
                break
            } else {
                inno = innovationHistory.count+1
                newInnovation = true
            }
        }
        
        let newConnection = Connection(innovation: inno, to: node2, from: node1, weight: randomWeight, enabled: true)
        
        connections.append(newConnection)
        if newInnovation {
            innovationHistory.append(newConnection)
        }
    }
    
    func fullyConnected()->Bool {
        var maxConnections = 0
        maxConnections += outputs * (nodes.count-outputs)
        maxConnections += (nodes.count-outputs-inputs) * (nodes.count-outputs-1)
        
        if maxConnections <= self.connections.count { //if the number of connections is equal to the max number of connections possible then it is full
            return true
        }
        return false
    }
    
    //feeding in input values varo the NN and returning output array
    func mutateWeight() {
        if connections.count > 0 {
            let rand2 = Double.random(in: 0 ..< 1)
            let random = GKRandomSource()
            let randGauss = GKGaussianDistribution(randomSource: random, lowestValue: -1000, highestValue: 1000)
            
            if rand2 < 0.01 { //10% of the time completely change the self.weight
                for i in 0..<connections.count {
                    connections[i].weight = Double.random(in: -1 ... 1)
                }
            } else { //otherwise slightly change it
                for i in 0..<connections.count {
                    connections[i].weight += (Double(randGauss.nextInt()) / 5000)
                    //keep self.weight between bounds
                    if connections[i].weight > 1 {
                        connections[i].weight = 1
                    }
                    if connections[i].weight < -1 {
                        connections[i].weight = -1
                    }
                }
            }
        }
    }
    
    func mutate(innovationHistory: inout [Connection]) {
        
        if connections.count == 0 {
            var nodeFrom = 0
            var nodeTo = 0
            var tries = 0
            repeat {
                nodeFrom = Int.random(in: 1 ... nodes.count)
                nodeTo = Int.random(in: 1 ... nodes.count)
                tries += 1
            } while (nodes[nodeFrom-1].type == 2 ||  nodes[nodeTo-1].type == 0) && (tries < 30)
            if tries == 30 {return}
            addConnection(from: nodeFrom, to: nodeTo, innovationHistory:&innovationHistory)
        }
        
        let rand1 = Double.random(in: 0 ... 1)
        if rand1 < 0.8 { // 80% of the time mutate weights
                mutateWeight()
        }
        
        //1% of the time add a node
        let rand3 = Double.random(in: 0 ... 1)
        if rand3 < 0.01 {
            addNode(innovationHistory:&innovationHistory)
            nodes[nodes.count-1].activation = Int.random(in: 0 ... 3)
        }
        
        //5% of the time add a new connection
        let rand2 = Double.random(in: 0 ... 1)
        if rand2 < 0.05 {
            if self.fullyConnected() {
                return
            }
            /*var nodeFrom = 0
            var nodeTo = 0
            var tries = 0
            repeat {
                nodeFrom = Int.random(in: 1 ... nodes.count)
                nodeTo = Int.random(in: 1 ... nodes.count)
                tries += 1
            } while (nodes[nodeFrom-1].type == 2 ||  nodes[nodeTo-1].type == 0) && (tries < 30)
            if tries == 30 {return}*/
            var nodeFrom = Int.random(in: 1 ... nodes.count)
            var nodeTo = Int.random(in: 1+inputs ... nodes.count)
            while (self.randomConnectionNodesAreShit(r1:nodeFrom, r2:nodeTo)) { //while the random self.nodes are no good
                //get new ones
                nodeFrom = Int.random(in: 1 ... nodes.count)
                nodeTo = Int.random(in: 1+inputs ... nodes.count)
            }
            addConnection(from: nodeFrom, to: nodeTo, innovationHistory:&innovationHistory)
        }
        
        
    }
    
    func randomConnectionNodesAreShit(r1:Int, r2:Int)->Bool {
        if nodes[r1-1].type == 2 ||  nodes[r2-1].type == 0 {return true}
        for i in 0..<connections.count {
            if connections[i].from == r1 && connections[i].to == r2 {return true} //if the self.nodes are already connected
        }
        return false;
    }
    
    //called when this Genome is better that the other parent
    func crossover(parent2:Genome)->Genome {
        let child = Genome(genomeInputs:self.inputs, genomeOutputs:self.outputs)
        child.connections.removeAll()
        child.nodes.removeAll()
        //all inherited genes
        for i in 0..<connections.count {
            var setEnabled = true //is this node in the chlid going to be enabled
            let parent2gene = self.matchingGene(parent2:parent2, innovationNumber:connections[i].innovation)
            if parent2gene != -1 { //if the genes match
                if !self.connections[i].enabled || !parent2.connections[parent2gene].enabled { //if either of the matching genes are disabled
                    if Double.random(in: 0...1) < 0.75 { //75% of the time disabel the childs gene
                        setEnabled = false;
                    }
                }
                let rand = Double.random(in: 0...1)
                if (rand < 0.5) {
                    child.connections.append(self.connections[i]);
                    //get gene from this fucker
                } else {
                    //get gene from parent2
                    child.connections.append(parent2.connections[parent2gene]);
                }
            } else { //disjoint or excess gene
                child.connections.append(self.connections[i]);
                setEnabled = connections[i].enabled;
            }
            child.connections[i].enabled = setEnabled
        }
        
        //since all excess and disjovar genes are inherrited from the more fit parent (this Genome) the childs structure is no different from this parent | with exception of dormant connections being enabled but this wont effect self.nodes
        //so all the self.nodes can be inherrited from this parent
        for i in 0..<self.nodes.count {
            child.nodes.append(self.nodes[i]);
        }
        return child
    }
    
    //returns whether or not there is a gene matching the input innovation number  in the input genome
    func matchingGene(parent2:Genome, innovationNumber:Int)->Int {
        for i in 0..<parent2.connections.count {
            if (parent2.connections[i].innovation == innovationNumber) {
                return i
            }
        }
        return -1; //no matching gene found
    }


    
    func mutateWeight0() {
        if connections.count > 0 {
            let randomConnection = Int.random(in: 0 ..< connections.count)
            if connections[randomConnection].enabled {
                self.connections[randomConnection].enabled = false
            } else {
                self.connections[randomConnection].enabled = true
            }
            
        }
    }
    
    
    
    func addNode(innovationHistory: inout [Connection]) {
        //pick a random connection to create a node between
        if connections.count > 0 {
            var randomConnection = Int.random(in: 0 ..< connections.count)
            var disabled = 0
            var biased = 0
            var disUnbiased = 0
            for i in 0..<connections.count {
                if !self.connections[i].enabled {
                    disabled += 1
                }
                if self.connections[i].from == 1 {
                    biased += 1
                }
                if self.connections[i].from != 1 && !self.connections[i].enabled{
                    disUnbiased += 1
                }
            }
            if connections.count == disabled {
                return
            }
            if connections.count == biased {
                return
            }
            if disUnbiased == connections.count - biased {
                return
            }
            
            while !self.connections[randomConnection].enabled || self.connections[randomConnection].from == 1 {
                randomConnection = Int.random(in: 0 ..< connections.count)
            }
            self.connections[randomConnection].enabled = false //disable it
            let newNodeNo = nodes.count+1 //create a new node
            self.nodes.append(Node(id: newNodeNo, type: 1));
            //add a new connection to the new node with a weight of 1
            addConnection(from: connections[randomConnection].from, to: newNodeNo, innovationHistory: &innovationHistory)
            self.connections[connections.count-1].weight = 1
            //add a new connection from the new node with a weight the same as the disabled connection
            addConnection(from: newNodeNo, to: connections[randomConnection].to, innovationHistory: &innovationHistory)
            self.connections[connections.count-1].weight = connections[randomConnection].weight
            //add bias
            if connections[randomConnection].from != 1 {
                addConnection(from: 1, to: newNodeNo, innovationHistory: &innovationHistory)
                connections[connections.count-1].weight = 0
            }
        } else {
            return
        }
    }
    
    func calculateMedian(array: [Double]) -> Double {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Double(sorted[(sorted.count - 1) / 2])
        }
    }
}
