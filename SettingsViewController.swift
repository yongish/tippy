//
//  SettingsViewController.swift
//  tippy
//
//  Created by Zhiyong Tan on 8/5/17.
//  Copyright © 2017 Zhiyong Tan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var defaultTipPercentage: UITextField!
    @IBOutlet weak var otherTipPercentage1: UITextField!
    @IBOutlet weak var otherTipPercentage2: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipPercentagesLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var other0Label: UILabel!
    @IBOutlet weak var other1Label: UILabel!
    @IBOutlet weak var themeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        defaultTipPercentage.text = String(defaults.integer(forKey: "defaultTipPercentage"))
        otherTipPercentage1.text = String(defaults.integer(forKey: "otherTipPercentage1"))
        otherTipPercentage2.text = String(defaults.integer(forKey: "otherTipPercentage2"))
        
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "theme")
        
        setTheme(view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save tip percentages to load in TipViewController.
        let defaults = UserDefaults.standard
        defaults.set(Int(defaultTipPercentage.text!), forKey: "defaultTipPercentage")
        defaults.set(Int(otherTipPercentage1.text!), forKey: "otherTipPercentage1")
        defaults.set(Int(otherTipPercentage2.text!), forKey: "otherTipPercentage2")
        
        // Save to theme to load in TipViewController.
        defaults.set(tipControl.selectedSegmentIndex, forKey: "theme")

        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setTheme(_ sender: Any) {

        
        // Set SettingsViewController theme options.
        if (tipControl.selectedSegmentIndex == 0) {
            // Light
            view.backgroundColor = UIColor.white
            tipControl.tintColor = UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            tipPercentagesLabel.textColor = UIColor.black
            defaultLabel.textColor = UIColor.black
            other0Label.textColor = UIColor.black
            other1Label.textColor = UIColor.black
            themeLabel.textColor = UIColor.black
        } else {
            // Dark
            view.backgroundColor = UIColor.black
            tipControl.tintColor = UIColor.white
            tipPercentagesLabel.textColor = UIColor.white
            defaultLabel.textColor = UIColor.white
            other0Label.textColor = UIColor.white
            other1Label.textColor = UIColor.white
            themeLabel.textColor = UIColor.white
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
