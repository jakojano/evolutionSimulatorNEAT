//
//  NeuralNetwork.swift
//  evolution_simulator
//
//  Created by Šimon Horna on 02/01/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation

class NeuralNetwork {
    
    var number_input_nodes = 0
    var number_middle_nodes = 0
    var number_middle2_nodes = 0
    var number_output_nodes = 0
    var input_nodes = [Float]()
    var middle_nodes = [Float]()
    var middle2_nodes = [Float]()
    var output_nodes = [Float]()
    var layer_one_weights = [Float]()
    var layer_two_weights = [Float]()
    var layer_three_weights = [Float]()
    
    func deactivate(){
        input_nodes.removeAll()
        middle_nodes.removeAll()
        middle2_nodes.removeAll()
        output_nodes.removeAll()
        layer_one_weights.removeAll()
        layer_two_weights.removeAll()
    }
    
    func setLayer1Weights(_ weights: [Float]) {
        //layer_one_weights.removeAll()
        for i in 0..<(number_input_nodes*number_middle_nodes) {
            
            let rand = arc4random()%UInt32(number_middle_nodes*number_output_nodes*9 )
            
            if rand == 1 {
                let r = Float.random(in: 0 ..< 20)
                let weight = (r/10)-1
                layer_one_weights[i] = weight
                print("mutoval")
            } else {
                layer_one_weights[i] = weights[i]
            }
        }
    }
    
    func setLayer2Weights(_ weights: [Float]) {
        //layer_two_weights.removeAll()
        for i in 0..<(number_middle_nodes*number_middle2_nodes) {
            
            let rand = arc4random()%UInt32(number_middle_nodes*number_middle2_nodes*9 )
            
            if rand == 1 {
                let r = Float.random(in: 0 ..< 20)
                let weight = (r/10)-1
                layer_two_weights[i] = weight
                print("mutoval")
            } else {
                layer_two_weights[i] = weights[i]
            }
        }
    }
    
    func setLayer3Weights(_ weights: [Float]) {
        //layer_three_weights.removeAll()
        for i in 0..<(number_middle2_nodes*number_output_nodes) {
            
            let rand = arc4random()%UInt32(number_middle2_nodes*number_output_nodes*9 )
            
            if rand == 1 {
                let r = Float.random(in: 0 ..< 20)
                let weight = (r/10)-1
                layer_three_weights[i] = weight
                print("mutoval")
            } else {
                layer_three_weights[i] = weights[i]
            }
        }
    }
    
    init( layer1 l1: Int, layer2 l2: Int, layer3 l3: Int, layer4 l4: Int ) {
        
        number_input_nodes = l1
        number_middle_nodes = l2
        number_middle2_nodes = l3
        number_output_nodes = l4
        
        input_nodes = [Float](repeating: Float(), count: number_input_nodes)
        middle_nodes = [Float](repeating: Float(), count: number_middle_nodes)
        middle2_nodes = [Float](repeating: Float(), count: number_middle2_nodes)
        output_nodes = [Float](repeating: Float(), count: number_output_nodes)
        
        layer_one_weights = [Float](repeating: Float(), count: number_input_nodes*number_middle_nodes)
        layer_two_weights = [Float](repeating: Float(), count: number_middle_nodes*number_middle2_nodes)
        layer_three_weights = [Float](repeating: Float(), count: number_middle2_nodes*number_output_nodes)
        
        
        // layer one-two weights
        for i in 0..<(number_input_nodes*number_middle_nodes) {
            let r = Float.random(in: 0 ..< 200)
            let weight = (r/100)-1
            layer_one_weights[i] = weight
        }
        
        // layer two-three weights
        for i in 0..<(number_middle_nodes*number_middle2_nodes) {
            let r = Float.random(in: 0 ..< 200)
            let weight = (r/100)-1
            layer_two_weights[i] = weight
        }
        
        // layer three-four weights
        for i in 0..<(number_middle2_nodes*number_output_nodes) {
            let r = Float.random(in: 0 ..< 200)
            let weight = (r/100)-1
            layer_three_weights[i] = weight
        }
    }
    
    func forwardPropagate() {
        self.calculateMiddleLayer()
        //    self.activateMiddleLayer()
        self.middle_nodes[5] = self.middle2_nodes[0]
        self.middle_nodes[6] = self.middle2_nodes[1]
        self.middle_nodes[7] = self.middle2_nodes[2]
        self.middle_nodes[8] = self.middle2_nodes[3]
        self.middle_nodes[9] = self.middle2_nodes[4]
        self.calculateMiddle2Layer()
        //    self.activateMiddleLayer()
        self.calculateOutputLayer()
        //    self.activateOutputLayer()
    }
    
    func calculateMiddleLayer() {
        // set middle nodes back to 0
        for i in 0..<number_middle_nodes {
            middle_nodes[i] = 0
        }
        // multiply weights and nodes
        var c: Float = 0
        for a in 0..<number_middle_nodes {
            for b in 0..<number_input_nodes{
                c += input_nodes[b]*layer_one_weights[b*number_middle_nodes+a]
            }
            //middle_nodes[a] = 1 / (1 + exp(-c))
            if c < 0 {
                middle_nodes[a] = 1 / (1 + exp(-c))
            } else {
                middle_nodes[a] = 1 / (1 + exp(-c))
            }
        }
        middle_nodes[number_middle_nodes-1] = input_nodes[15]
    }
    
    func calculateMiddle2Layer() {
        // set middle nodes back to 0
        for i in 0..<number_middle2_nodes {
            middle2_nodes[i] = 0
        }
        // multiply weights and nodes
        var c: Float = 0
        for a in 0..<number_middle2_nodes {
            for b in 0..<number_middle_nodes{
                c += input_nodes[b]*layer_two_weights[b*number_middle2_nodes+a]
            }
            //middle_nodes2[a] = 1 / (1 + exp(-c))
            if c < 0 {
                middle2_nodes[a] = 1 / (1 + exp(-c))
            } else {
                middle2_nodes[a] = 1 / (1 + exp(-c))
            }
        }
        middle2_nodes[number_middle2_nodes-1] = input_nodes[15]
    }
    
    func calculateOutputLayer() {
        // set output nodes back to 0
        for i in 0..<number_output_nodes {
            output_nodes[i] = 0
        }
        // multiply weights and nodes
        var c: Float = 0
        for a in 0..<number_output_nodes {
            for b in 0..<number_middle2_nodes{
                c += middle2_nodes[b]*layer_three_weights[b*number_output_nodes+a]
            }
            //output_nodes[a] = 1 / (1 + exp(-c))
            if c < 0 {
                output_nodes[a] = 1/(1 + exp(-0.5*c))
            } else {
                output_nodes[a] = 1/(1 + exp(-0.5*c))
            }
        }
    }
    
    func updateInputNodes(l1: inout [Float]) {
        self.input_nodes = l1
    }
}
