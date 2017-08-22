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
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var subTipLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var divide2Label: UILabel!
    @IBOutlet weak var divide3Label: UILabel!
    @IBOutlet weak var divide4Label: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    
    
    var tipPercentages = [18, 20, 25]
    var defaultIndex = 0
    
    var flag = true
    var kbflag = true
    
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
                tipControl.setTitle(String(format: "%i%@", tipPercentages[i], "%") , forSegmentAt: i)
            }
        }
        
        let theme = defaults.integer(forKey: "theme")
        print("theme", theme)
        if (theme == 0) {
            billField.textColor = UIColor.black
            billSubView.backgroundColor = UIColor.white
            subView.backgroundColor = UIColor.lightGray
            tipControl.tintColor = UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            plusLabel.textColor = UIColor.black
            subTipLabel.textColor = UIColor.black
            subTotalLabel.textColor = UIColor.black
            divide2Label.textColor = UIColor.black
            divide3Label.textColor = UIColor.black
            divide4Label.textColor = UIColor.black
        } else {
            billField.textColor = UIColor.white
            billSubView.backgroundColor = UIColor.darkGray
            subView.backgroundColor = UIColor.black
            tipControl.tintColor = UIColor.white
            plusLabel.textColor = UIColor.white
            subTipLabel.textColor = UIColor.white
            subTotalLabel.textColor = UIColor.white
            divide2Label.textColor = UIColor.white
            divide3Label.textColor = UIColor.white
            divide4Label.textColor = UIColor.white
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
            self.tipControl.frame = CGRect(x: 8, y: 150, width: self.tipControl.frame.width, height: self.tipControl.frame.height)
            self.subView.transform = top
        }, completion: nil)
    }
    
    func slideDown(duration: Double = 0.4) {
        billSubView.frame = CGRect(x: 0 , y: 55, width: billSubView.frame.width, height: billSubView.frame.height + 110)

        let btm = CGAffineTransform(translationX: 0, y: 110)
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            self.subView.transform = btm
            self.tipControl.frame = CGRect(x: 8, y: 250, width: self.tipControl.frame.width, height: self.tipControl.frame.height)
        }, completion: nil)
    }

    @IBAction func onTap(_ sender: AnyObject) {
        
        
        // Save the bill in case user exits app.
        let defaults = UserDefaults.standard
        defaults.set(billField.text, forKey: "billField")
        defaults.synchronize()
        
        print("entered bill")
        
        subView.isHidden = false
        
//        if (kbflag == true) {
//            slideDown()
//        }
        kbflag = true
        
        flag = true

        view.inputView?.becomeFirstResponder()
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        print("editing begin")

        if (flag) {
            slideUp()
        }
        flag = false
        fillLabels()
    }
    
    @IBAction func onTapPercentage(_ sender: Any) {
        view.endEditing(true)
        kbflag = false
    }
    
    func fillLabels() {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentages[tipControl.selectedSegmentIndex]) / 100
        let total = bill + tip
        
        let currencySymbol = Locale.current.currencySymbol!

        subTotalLabel.text = String(format: "%@%.2f", locale: Locale.current, currencySymbol, total)
        subTipLabel.text = String(format: "%@%.2f", locale: Locale.current, currencySymbol, tip)
        
    }
}

