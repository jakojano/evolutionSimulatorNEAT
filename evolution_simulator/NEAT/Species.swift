//
//  Species.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 23/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation

class Species {
    
    var players = [Player]()
    var bestFitness = 0
    var champ = Player()
    var averageFitness = 0
    var staleness = 0; //how many generations the species has gone without an improvement
    var rep = Genome(genomeInputs: 10, genomeOutputs: 5)
    //--------------------------------------------
    //coefficients for testing compatibility
    var excessCoeff = 1
    var weightDiffCoeff = Double(0.5)
    var compatibilityThreshold = Double(0.3)
    
    init( p:Player ) {
        self.players.append(p)
        //since it is the only one in the species it is by default the best
        self.bestFitness = p.age
        self.rep = p.brain
        self.champ = p
    }
    
    //returns whether the parameter genome is in this species
    func sameSpecies(g:Genome)->Bool {
        var compatibility = Double()
        let excessAndDisjoint = self.getExcessDisjoint(brain1:g, brain2:self.rep) //get the number of excess and disjoint genes between this player and the current species self.rep
        let averageWeightDiff = self.averageWeightDiff(brain1:g, brain2:self.rep) //get the average weight difference between matching genes
        
        var largeGenomeNormaliser = g.connections.count - 20
        if (largeGenomeNormaliser < 1) {
            largeGenomeNormaliser = 1;
        }
        
        compatibility = Double((self.excessCoeff * excessAndDisjoint / largeGenomeNormaliser)) + (self.weightDiffCoeff * averageWeightDiff) //compatibility formula
        return (self.compatibilityThreshold > compatibility)
    }
    
    //add a player to the species
    func addToSpecies(p:Player) {
        self.players.append(p)
    }
    
    //returns the number of excess and disjoint genes between the 2 input genomes
    //i.e. returns the number of genes which dont match
    func getExcessDisjoint(brain1:Genome, brain2:Genome)->Int {
        var matching = 0
        for i in 0..<brain1.connections.count {
            for j in 0..<brain2.connections.count {
                if brain1.connections[i].innovation == brain2.connections[j].innovation {
                    matching += 1
                    break;
                }
            }
        }
        return (brain1.connections.count + brain2.connections.count - 2 * matching); //return no of excess and disjoint genes
    }
    
    //returns the avereage weight difference between matching genes in the input genomes
    func averageWeightDiff(brain1:Genome, brain2:Genome)->Double {
        if brain1.connections.count == 0 || brain2.connections.count == 0 {
            return 0
        }
        
        var matching = 0
        var totalDiff = Double(0)
        for i in 0..<brain1.connections.count {
            for j in 0..<brain2.connections.count {
                if (brain1.connections[i].innovation == brain2.connections[j].innovation) {
                    matching += 1
                    totalDiff += abs(brain1.connections[i].weight - brain2.connections[j].weight)
                    break;
                }
            }
        }
        if (matching == 0) { //divide by 0 error
            return 100;
        }
        return totalDiff / Double(matching)
    }
    
    //sorts the species by fitness
    func sortSpecies() {
        var temp = [Player]() // new ArrayList < Player > ();
        //selection short
        while !self.players.isEmpty {
            var max = 0
            var maxIndex = 0
            for j in 0..<self.players.count {
                if self.players[j].age > max {
                    max = self.players[j].age
                    maxIndex = j
                }
            }
            temp.append(self.players[maxIndex])
            self.players.remove(at: maxIndex)
            // self.players.remove(maxIndex)
        }
        self.players = temp
        if self.players.count == 0 {
            self.staleness = 200
            return
        }
        //if new best player
        if self.players[0].age > self.bestFitness {
            self.staleness = 0
            self.bestFitness = self.players[0].age
            self.rep = self.players[0].brain
            self.champ = self.players[0]
        } else { //if no new best player
            self.staleness += 1
        }
    }
    
    //simple stuff
    func setAverage() {
        var sum = 0
        for i in 0..<self.players.count {
            sum += self.players[i].age
        }
        self.averageFitness = sum / self.players.count
    }
    
    //gets baby from the self.players in this species
    func giveMeBaby(innovationHistory:inout [Connection])->Player {
        var baby = Player()
        if Double.random(in: 0...1) < 0.25 { //25% of the time there is no crossover and the child is simply a clone of a random(ish) player
            baby = self.selectPlayer()
        } else { //75% of the time do crossover
            //get 2 random(ish) parents
            let parent1 = self.selectPlayer()
            let parent2 = self.selectPlayer()
            //the crossover function expects the highest fitness parent to be the object and the lowest as the argument
            if parent1.age < parent2.age {
                baby = parent2.crossover(parent2:parent1)
                baby.diet = parent2.diet
                baby.lastPosition = parent2.lastPosition
            } else {
                baby = parent1.crossover(parent2:parent2)
                baby.diet = parent1.diet
                baby.lastPosition = parent1.lastPosition
            }
        }
        baby.brain.mutate(innovationHistory: &innovationHistory); //mutate that baby brain
        return baby;
    }
    
    //selects a player based on it fitness
    func selectPlayer()->Player {
        var fitnessSum = 0
        for i in 0..<self.players.count {
            fitnessSum += self.players[i].age
        }
        let rand = Int.random(in: 0...fitnessSum)
        var runningSum = 0
        
        for i in 0..<self.players.count {
            runningSum += self.players[i].age
            if (runningSum > rand) {
                return self.players[i]
            }
        }
        //unreachable code to make the parser happy
        return self.players[0]
    }
    
    //kills off bottom half of the species
    func cull() {
        if self.players.count > 2 {
            let polovica = self.players.count/2
            while self.players.count > polovica {
                // this.players.remove(i);
                self.players.remove(at: self.players.count-1)
            }
        }
    }
    
    //in order to protect unique this.players, the fitnesses of each player is divided by the number of this.players in the species that that player belongs to
    func fitnessSharing() {
        for i in 0..<self.players.count {
        self.players[i].age /= self.players.count
      }
    }
    
    
    
}
