//
//  SettingsViewController.swift
//  evolution_simulator_NEAT
//
//  Created by Šimon Horna on 20/09/2020.
//  Copyright © 2020 Šimon Horna. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var populationSet: NSPopUpButton!
    @IBOutlet weak var populationSlider: NSSlider!
    @IBOutlet weak var populationTextField: NSTextField!
    @IBOutlet weak var foodSet: NSPopUpButton!
    @IBOutlet weak var foodSlider: NSSlider!
    @IBOutlet weak var foodTextField: NSTextField!
    @IBOutlet weak var stonesSet: NSPopUpButton!
    @IBOutlet weak var stonesSlider: NSSlider!
    @IBOutlet weak var stonesTextField: NSTextField!
    var prefs = Preferences()
    
    func showExistingPrefs() {
        let selectedPopulation = prefs.population
        populationSet.selectItem(withTitle: "Custom")
        populationSlider.isEnabled = true
        for item in populationSet.itemArray {
            if item.tag == selectedPopulation {
                populationSet.select(item)
                populationSlider.isEnabled = false
                break
            }
        }
        populationSlider.integerValue = selectedPopulation
        let selectedFoods = prefs.foods
        foodSet.selectItem(withTitle: "Custom")
        foodSlider.isEnabled = true
        for item in foodSet.itemArray {
            if item.tag == selectedFoods {
                foodSet.select(item)
                foodSlider.isEnabled = false
                break
            }
        }
        foodSlider.integerValue = selectedFoods
        let selectedStones = prefs.stones
        stonesSet.selectItem(withTitle: "Custom")
        stonesSlider.isEnabled = true
        for item in stonesSet.itemArray {
            if item.tag == selectedStones {
                stonesSet.select(item)
                stonesSlider.isEnabled = false
                break
            }
        }
        stonesSlider.integerValue = selectedStones
        showSliderValueAsText()
    }
    
    func showSliderValueAsText() {
        let newPopCount = populationSlider.integerValue
        let newFoodCount = foodSlider.integerValue
        let newStnCount = stonesSlider.integerValue
        let creaturesDescription = (newPopCount == 1) ? "creature" : "creatures"
        let plantsDescription = (newFoodCount == 1) ? "plant" : "plants"
        let stonesDescription = (newStnCount == 1) ? "stone" : "stones"
        populationTextField.stringValue = "\(newPopCount) \(creaturesDescription)"
        foodTextField.stringValue = "\(newFoodCount) \(plantsDescription)"
        stonesTextField.stringValue = "\(newStnCount) \(stonesDescription)"
    }
    
    func saveNewPrefs() {
        print("saving new preferences")
        prefs.population = populationSlider.integerValue
        prefs.foods = foodSlider.integerValue
        prefs.stones = stonesSlider.integerValue
        print("preferences saved")
        print("sending notification")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"), object: nil)
        print("notification sent")
    }
    
    @IBAction func populationChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            populationSlider.isEnabled = true
            return
        }
        let newPopCount = sender.selectedTag()
        populationSlider.integerValue = newPopCount
        showSliderValueAsText()
        populationSlider.isEnabled = false
    }
    @IBAction func populationSliderChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    @IBAction func foodsChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            foodSlider.isEnabled = true
            return
        }
        let newfoodCount = sender.selectedTag()
        foodSlider.integerValue = newfoodCount
        showSliderValueAsText()
        foodSlider.isEnabled = false
    }
    @IBAction func foodsSliderChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    @IBAction func stonesChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            stonesSlider.isEnabled = true
            return
        }
        let newstonesCount = sender.selectedTag()
        stonesSlider.integerValue = newstonesCount
        showSliderValueAsText()
        stonesSlider.isEnabled = false
    }
    @IBAction func stonesSliderChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    
    @IBAction func restartClicked(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
}
