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

    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabelLabel: UILabel!
    @IBOutlet weak var totalLabelLabel: UILabel!
    
    var tipPercentages = [18, 20, 25]
    var defaultIndex = 0
    
    let collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 200)
        let col = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        col.layer.borderColor = UIColor.red.cgColor
        col.layer.borderWidth = 1.0
        col.backgroundColor = UIColor.yellow
        return col
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.clearBillField), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.billField.becomeFirstResponder()
        
        
        view.addSubview(collectionView)
    }
    
    // Clear UserDefaults bill if it has been more than 5 seconds (demo purpose; supposed to be 10 min).
    func clearBillField() {
        let LIMIT = 5
        let defaults = UserDefaults.standard
        let savedTime = defaults.object(forKey: "exitTime")
        let savedBill = defaults.string(forKey: "savedBill")
        if (savedTime != nil) {
            let intervalSeconds = Int(NSDate().timeIntervalSince(savedTime as! Date))
            print("INTERVAL SECS", intervalSeconds)
            if (intervalSeconds > LIMIT) {
                billField.text = ""
            } else if (savedBill != nil) {
                billField.text = savedBill
            }
        }
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
        
        let theme = defaults.integer(forKey: "theme")
        print("theme", theme)
        if (theme == 0) {
            view.backgroundColor = UIColor.white
            tipLabel.textColor = UIColor.black
            totalLabel.textColor = UIColor.black
            billLabel.textColor = UIColor.black
            tipLabelLabel.textColor = UIColor.black
            totalLabelLabel.textColor = UIColor.black
        } else {
            view.backgroundColor = UIColor.black
            tipLabel.textColor = UIColor.white
            totalLabel.textColor = UIColor.white
            billLabel.textColor = UIColor.white
            tipLabelLabel.textColor = UIColor.white
            totalLabelLabel.textColor = UIColor.white
        }
        
        // Calculate bill based on default.
        fillLabels()
        
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
        
        // Save the bill in case user exits app.
        let defaults = UserDefaults.standard
        defaults.set(billField.text, forKey: "billField")
        defaults.synchronize()
        
        print("entered bill")
        
        view.endEditing(true)
        
        
        collectionView.removeFromSuperview()
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
                print("editing begin")
        view.addSubview(collectionView)

        fillLabels()
    }
    
    func fillLabels() {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentages[tipControl.selectedSegmentIndex]) / 100
        let total = bill + tip
        
        let currencySymbol = Locale.current.currencySymbol!
        
        totalLabel.text = String(format: "%@%.2f", locale: Locale.current, currencySymbol, total)
        tipLabel.text = String(format: "%@%.2f", locale: Locale.current, currencySymbol, tip)
    }
}

