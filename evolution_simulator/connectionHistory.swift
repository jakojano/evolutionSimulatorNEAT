//
//  connectionHistory.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 22/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation

class connectionHistory {
    
    var fromNode = Int()
    var toNode = Int()
    var innovationNumber = Int()
    var innovationNumbers = [Int]()
    
    var nodeRecord = [Node]()
    var linkInnovations = [connectionGene]()
    var nodeCounter = 0
    var innovationCounter = 0
    
    init( from:Int, to:Int, inno:Int, innovationNos:[Int] ) {
        self.fromNode = from
        self.toNode = to
        self.innovationNumber = inno
        self.innovationNumbers = innovationNos //the innovation Numbers from the connections of the genome which first had this mutation
        //this represents the genome and allows us to test if another genoeme is the same
        //this is before this connection was added
    }
    
    //returns whether the genome matches the original genome and the connection is between the same nodes
    func matches(genome:Genome, from:Node, to:Node)->Bool {
        if genome.genes.count == self.innovationNumbers.count { //if the number of connections are different then the genomes aren't the same
            if from.number == self.fromNode && to.number == self.toNode {
                //next check if all the innovation numbers match from the genome
                for i in 0..<genome.genes.count {
                    if !self.innovationNumbers.contains(genome.genes[i].innovationNo) {
                        return false;
                    }
                }
                //if reached this far then the innovationNumbers match the genes innovation numbers and the connection is between the same nodes
                //so it does match
                return true;
            }
        }
        return false;
    }
    
    
}
