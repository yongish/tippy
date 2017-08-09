//
//  ViewController.swift
//  tippy
//
//  Created by Zhiyong Tan on 8/5/17.
//  Copyright © 2017 Zhiyong Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    var tipPercentages = [18, 20, 25]
    var defaultIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load tip percentages set in SettingsViewController.
        let defaults = UserDefaults.standard
        if (defaults.integer(forKey: "defaultTipPercentage") != 0) {
            tipPercentages[0] = defaults.integer(forKey: "defaultTipPercentage")
            let defaultTipPercentage = tipPercentages[0]
            tipPercentages[1] = defaults.integer(forKey: "otherTipPercentage1")
            tipPercentages[2] = defaults.integer(forKey: "otherTipPercentage2")
            
            tipPercentages.sort()
            
            if (defaultTipPercentage == tipPercentages[1]) {
                tipControl.selectedSegmentIndex = 1
                defaultIndex = 1
            } else if (defaultTipPercentage == tipPercentages[2]) {
                tipControl.selectedSegmentIndex = 2
                defaultIndex = 2
            } else {
                tipControl.selectedSegmentIndex = 0
                defaultIndex = 0
            }
            
            for i in 0..<tipControl.numberOfSegments {
                tipControl.setTitle(String(tipPercentages[i]), forSegmentAt: i)
            }
        }
        
        // Calculate bill based on default.
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentages[tipControl.selectedSegmentIndex]) / 100
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        
        if (defaultIndex == 0) {
            defaults.set(tipPercentages[0], forKey: "defaultTipPercentage")
            defaults.set(tipPercentages[1], forKey: "otherTipPercentage1")
            defaults.set(tipPercentages[2], forKey: "otherTipPercentage2")
        } else if (defaultIndex == 1) {
            defaults.set(tipPercentages[0], forKey: "otherTipPercentage1")
            defaults.set(tipPercentages[1], forKey: "defaultTipPercentage")
            defaults.set(tipPercentages[2], forKey: "otherTipPercentage2")
        } else {
            defaults.set(tipPercentages[0], forKey: "otherTipPercentage1")
            defaults.set(tipPercentages[1], forKey: "otherTipPercentage2")
            defaults.set(tipPercentages[2], forKey: "defaultTipPercentage")
        }
        
        
        defaults.synchronize()
        
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("view did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentages[tipControl.selectedSegmentIndex]) / 100
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

