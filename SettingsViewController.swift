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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save tip percentages to load in TipViewController.
        let defaults = UserDefaults.standard
        defaults.set(Int(defaultTipPercentage.text!), forKey: "defaultTipPercentage")
        defaults.set(Int(otherTipPercentage1.text!), forKey: "otherTipPercentage1")
        defaults.set(Int(otherTipPercentage2.text!), forKey: "otherTipPercentage2")
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
