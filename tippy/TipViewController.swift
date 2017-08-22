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

    
    @IBOutlet weak var subTipLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    
    
    var tipPercentages = [18, 20, 25]
    var defaultIndex = 0
    
    var flag = true
    
    @IBOutlet weak var billSubView: UIView!
    @IBOutlet weak var subView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.clearBillField), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.billField.becomeFirstResponder()
        
        // Hacky way. Hide the subview, slide it down, then unhide it.
        subView.isHidden = true
        view.addSubview(subView)
        slideDown(duration: 0.0)
//        subView.isHidden = false
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
//            billLabel.textColor = UIColor.black
//            tipLabelLabel.textColor = UIColor.black
//            totalLabelLabel.textColor = UIColor.black
        } else {
            view.backgroundColor = UIColor.black
            tipLabel.textColor = UIColor.white
            totalLabel.textColor = UIColor.white
//            billLabel.textColor = UIColor.white
//            tipLabelLabel.textColor = UIColor.white
//            totalLabelLabel.textColor = UIColor.white
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
    
    func slideUp() {
        subView.isHidden = false
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.billSubView.transform = top
            self.tipControl.frame = CGRect(x: 10, y: 150, width: self.tipControl.frame.width, height: self.tipControl.frame.height)
            self.subView.transform = top
        }, completion: nil)
    }
    
    func slideDown(duration: Double = 0.4) {
        billSubView.frame = CGRect(x: 0 , y: 55, width: billSubView.frame.width, height: billSubView.frame.height + 110)

        let btm = CGAffineTransform(translationX: 0, y: 110)
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            self.subView.transform = btm
            self.tipControl.frame = CGRect(x: 10, y: 250, width: self.tipControl.frame.width, height: self.tipControl.frame.height)
        }, completion: nil)
    }

    @IBAction func onTap(_ sender: AnyObject) {
        
        // Save the bill in case user exits app.
        let defaults = UserDefaults.standard
        defaults.set(billField.text, forKey: "billField")
        defaults.synchronize()
        
        print("entered bill")
        
        subView.isHidden = false
        slideDown()
        
        flag = true
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        print("editing begin")

        if (flag) {
            slideUp()
        }
        flag = false
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

