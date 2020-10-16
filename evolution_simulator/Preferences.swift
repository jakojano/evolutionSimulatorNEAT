//
//  Settings.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 23/09/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Foundation
struct Preferences {
    
    var population: Int {
        get {
            let popCount = UserDefaults.standard.integer(forKey: "population")
            if popCount > 0 {
                return popCount
            }
            return 30
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "population")
        }
    }
    
    var foods: Int {
        get {
            let foodCount = UserDefaults.standard.integer(forKey: "foods")
            if foodCount > 0 {
                return foodCount
            }
            return 100
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "foods")
        }
    }
    
    var stones: Int {
        get {
            let stnCount = UserDefaults.standard.integer(forKey: "stones")
            if stnCount > 0 {
                return stnCount
            }
            return 12
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "stones")
        }
    }
    
}
