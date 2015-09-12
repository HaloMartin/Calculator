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
//        userIsInTheMiddleOfTypingANumber = false
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            brain.pushOperation(operation)
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
            brain.pushOperand(displayValue)
        }else{
            brain.removeAllOperand()
            userClearing = false
        }
    }
    
    @IBAction func equals(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let result = brain.performEquals(){
            displayValue = result
        }else{
            displayValue = 0
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

