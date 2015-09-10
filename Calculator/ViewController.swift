//
//  ViewController.swift
//  Calculator
//
//  Created by 朱进林 on 15/9/6.
//  Copyright (c) 2015年 朱进林. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber:Bool = false
    var userClearing:Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text! = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        println("digit = \(digit)")
    }
    
    @IBAction func operate(sender: UIButton) {
//        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        displayValue = 0
        userClearing = true
        enter()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if !userClearing{
            if let result = brain.pushOperand(displayValue){
                displayValue = result
            }else{
                displayValue = 0
            }
        }else{
            brain.removeAllOperand()
            userClearing = false
        }
    }
    var displayValue:Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

