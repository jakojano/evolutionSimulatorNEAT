//
//  Population.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 26/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//
/*
import Foundation
import SpriteKit
import GameplayKit

class Population {
    
    var players = [Player]()
    var bestPlayer = Player()
    var bestScore = Int()
    var globalBestScore = Int()
    var gen = Int()
    var innovationHistory = [Connection]()
    var genPlayers = [Player]()
    var species = [Species]()
    
    var massExtinctionEvent = false
    var newStage = false
    
    init( size:Int ) {
        for _ in 0..<size {
            let creature = Player(imageNamed: "potvorka")
            // Determine where to spawn the monster along the Y and X axis
            let actualY = random(min: 10, max: 790)
            let actualX = random(min: 10, max: 790)
            /*if r < 0.5 {
             r = 0
             } else {r = 1}*/
            let r = CGFloat.random(in: 0 ..< 1)
            creature.diet = r
            // Position the monster
            creature.position = CGPoint(x: (Int(actualX)), y: Int(actualY))
            creature.color = SKColor.yellow
            creature.colorBlendFactor = 0.5
            creature.size = CGSize(width: 8,height: 8)
            creature.blendMode = .replace
            //Eyes
            creature.addEyes()
            creature.addSignals()
            // Collision
            creature.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4,height: 4))
            creature.physicsBody?.affectedByGravity = false
            creature.physicsBody?.isDynamic = true
            creature.physicsBody?.categoryBitMask = ColliderType.Creature
            creature.physicsBody?.collisionBitMask = ColliderType.Food | ColliderType.Creature
            creature.physicsBody?.contactTestBitMask = ColliderType.Food | ColliderType.Creature
            creature.physicsBody?.friction = 1.0
            creature.physicsBody?.linearDamping = 1.0
            self.players.append(creature)
            self.players[self.players.count - 1].brain.mutate(innovationHistory: &self.innovationHistory)
        }
    }
    
    func updateAlive() {
        for i in 0..<self.players.count {
            if self.players[i].alive {
                //self.players[i].look(); //get inputs for brain
                //self.players[i].think(); //use outputs from neural network
                //self.players[i].update(); //move the player according to the outputs from the neural network
                //if (!showNothing && (!showBest || i == 0)) {
                    //self.players[i].show()
                }
                if (self.players[i].score > self.globalBestScore) {
                    self.globalBestScore = self.players[i].score;
                }
            }
        }
    }
    
    //returns true if all the players are dead      sad
    func done()->Bool {
        for i in 0..<self.players.count {
            if self.players[i].alive {
                return false
            }
        }
        return true
    }
    
    //sets the best player globally and for thisself.gen
    func setBestPlayer() {
        let tempBest = self.species[0].players[0]
        tempBest.gen = self.gen
        
        //if best thisself.gen is better than the global best score then set the global best as the best thisself.gen
        
        if (tempBest.score >= self.bestScore) {
            self.genPlayers.append(tempBest)
            print("old best: ", self.bestScore)
            print("new best: ", tempBest.score)
            self.bestScore = tempBest.score
            self.bestPlayer = tempBest
        }
    }
    
    //this function is called when all the players in the self.players are dead and a newself.generation needs to be made
    func naturalSelection() {
        // self.batchNo = 0;
        let previousBest = self.players[0]
        self.speciate(); //seperate the self.players varo self.species
        self.calculateFitness(); //calculate the fitness of each player
        self.sortSpecies(); //sort the self.species to be ranked in fitness order, best first
        if (self.massExtinctionEvent) {
            self.massExtinction();
            self.massExtinctionEvent = false;
        }
        self.cullSpecies() //kill off the bottom half of each self.species
        self.setBestPlayer() //save the best player of thisself.gen
        self.killStaleSpecies(); //remove self.species which haven't improved in the last 15(ish)self.generations
        self.killBadSpecies(); //kill self.species which are so bad that they cant reproduce
        
        // if (self.gensSinceNewWorld >= 0 || self.bestScore > (grounds[0].distance - 350) / 10) {
        //   self.gensSinceNewWorld = 0;
        //   console.log(self.gensSinceNewWorld);
        //   console.log(self.bestScore);
        //   console.log(grounds[0].distance);
        //   newWorlds();
        // }
        
        print("generation  ", self.gen, "  Number of mutations  ", self.innovationHistory.count, "  species:   ", self.species.count, "  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        
        
        let averageSum = self.getAvgFitnessSum()
        var children = [Player]()
        for j in 0..<self.species.count { //for each self.species
            children.append(self.species[j].champ); //add champion without any mutation
            let NoOfChildren = Int(self.species[j].averageFitness / averageSum * self.players.count) - 1; //the number of children this self.species is allowed, note -1 is because the champ is already added
            for _ in 0..<NoOfChildren { //get the calculated amount of children from this self.species
                children.append(self.species[j].giveMeBaby(innovationHistory: &self.innovationHistory));
            }
        }
        if (children.count < self.players.count) {
            children.append(previousBest);
        }
        while (children.count < self.players.count) { //if not enough babies (due to flooring the number of children to get a whole var)
            children.append(self.species[0].giveMeBaby(innovationHistory: &self.innovationHistory)); //get babies from the best self.species
        }
        
        self.players = children //set the children as the current self.playersulation
        self.gen += 1
    }
    
    //seperate self.players into self.species based on how similar they are to the leaders of each self.species in the previousself.gen
    func speciate() {
        for s in self.species { //empty self.species
            s.players = []
        }
        for i in 0..<self.players.count { //for each player
            var speciesFound = false
            for s in self.species { //for each self.species
                if (s.sameSpecies(g: self.players[i].brain)) { //if the player is similar enough to be considered in the same self.species
                    s.addToSpecies(p: self.players[i]) //add it to the self.species
                    speciesFound = true
                    break
                }
            }
            if !speciesFound { //if no self.species was similar enough then add a new self.species with this as its champion
                self.species.append(Species(p: self.players[i]))
            }
        }
    }
    
    //calculates the fitness of all of the players
    func calculateFitness() {

    }
    
    //sorts the players within a self.species and the self.species by their fitnesses
    func sortSpecies() {
        //sort the players within a self.species
        for s in self.species {
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
            // self.species.remove(maxIndex);
        }
        self.species = temp
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
        var temp = [Species]()
        temp.append(self.species[0])
        for i in 1..<self.species.count {
            if self.species[i].averageFitness / averageSum * self.players.count >= 1 { //if wont be given a single child
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
    
    //kill the bottom half of each self.species
    func cullSpecies() {
        for s in self.species {
            s.cull(); //kill bottom half
            s.fitnessSharing(); //also while we're at it lets do fitness sharing
            s.setAverage(); //reset averages because they will have changed
        }
    }
    
    
    func massExtinction() {
        var temp = [Species]()
        if self.species.count > 5 {
            for i in 0...4 {
                // self.species.remove(i); //sad
                temp.append(self.species[i])
            }
            self.species = temp
        }
    }
    
    //BATCH LEARNING
    
    //update all the players which are alive
    /*func updateAliveInBatches() {
        var aliveCount = 0
        for i in 0..<self.players.count {
            if self.playerInBatch(player: self.players[i]) {
                
                if self.players[i].alive {
                    aliveCount += 1
                    self.players[i].look(); //get inputs for brain
                    self.players[i].think(); //use outputs from neural network
                    self.players[i].update(); //move the player according to the outputs from the neural network
                    if !showNothing && (!showBest || i == 0) {
                        self.players[i].show();
                    }
                    if (self.players[i].score > self.globalBestScore) {
                        self.globalBestScore = self.players[i].score;
                    }
                }
            }
        }
        
        if (aliveCount == 0) {
            self.batchNo += 1
        }
    }
    
    
    func playerInBatch(player:Player)->Bool {
        for i in self.batchNo * self.worldsPerBatch..<min((self.batchNo + 1) * self.worldsPerBatch, worlds.count) {
            if player.world == worlds[i] {
                return true
            }
        }
        return false
    }
    
    func stepWorldsInBatch() {
        for i in self.batchNo * self.worldsPerBatch..<min((self.batchNo + 1) * self.worldsPerBatch, worlds.count) {
            worlds[i].Step(1 / 30, 10, 10);
        }
    }
    
    //returns true if all the players in a batch are dead      sad
    func batchDead()->Bool {
        for  i in self.batchNo * self.playersPerBatch..<min((self.batchNo + 1) * self.playersPerBatch, self.players.count) {
            if self.players[i].alive {
                return false;
            }
        }
        return true;
    }*/
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
}
*/
