//
//  ConnectionGene.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 15/03/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation

public struct Connection {
    
    let innovation: Int
    let to: Int
    let from: Int
    var weight: Double
    var enabled: Bool
    
    init(innovation: Int, to: Int, from: Int, weight: Double, enabled: Bool) {
        self.innovation = innovation
        self.to = to
        self.from = from
        self.weight = weight
        self.enabled = enabled
    }
}

extension Connection: Equatable {
    public static func == (lhs: Connection, rhs: Connection) -> Bool {
        return
            lhs.innovation == rhs.innovation &&
            lhs.weight == rhs.weight &&
            lhs.enabled == rhs.enabled
    }
}
