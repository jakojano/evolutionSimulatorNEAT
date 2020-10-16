//
//  NodeGene.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 16/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

public struct Node {
    
    let id: Int
    let type: Int
    var activation: Int
    var inputSum : Double
    var buffer : Double
    var outputValue : Double
    var x : Double
    var y : Double
    var ConnectionNo = 0
    var xSum = Double(0.0)
    var ySum = Double(0.0)
    var inx = Set<Double>()
    var outx = Set<Double>()
    var iny = Set<Double>()
    var outy = Set<Double>()
    
    init(id: Int, type: Int) {
        self.id = id
        //type0-input type1-hidden type2-output
        self.type = type
        //activation0-sigmoid activation1-ReLu activation2-step activation3-gaussian
        self.activation = 0
        self.inputSum = 0
        self.buffer = 0
        self.outputValue = 0
        self.x = 0.5
        self.y = 0.5
    }
    
}

