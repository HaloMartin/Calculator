//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 朱进林 on 15/9/8.
//  Copyright (c) 2015年 朱进林. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op:Printable
    {
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
        case BracketOperation(String)
        
        var description: String{
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .BracketOperation(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    private var endFlag = Bool(false)
    
    init(){
        knowOps["×"] = Op.BinaryOperation("×",*)
        knowOps["÷"] = Op.BinaryOperation("÷"){$1/$0}
        knowOps["+"] = Op.BinaryOperation("+",+)
        knowOps["-"] = Op.BinaryOperation("-"){$1-$0}
        knowOps["√"] = Op.UnaryOperation("√",sqrt)
        knowOps["("] = Op.BracketOperation("(")
        knowOps[")"] = Op.BracketOperation(")")
        endFlag = Bool(false)
    }
    private func evaluate(preOp: Double,ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            let preOperand = preOp
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                println("操作数：\(operand)")
                let op1Evaluation = evaluate(operand,ops:remainingOps)
                if let operand2 = op1Evaluation.result{
                    return (operand2,op1Evaluation.remainingOps)
                }else{
                    return (operand,op1Evaluation.remainingOps)
                }
            case .UnaryOperation(_,let operation):
                return (operation(preOperand),remainingOps)
            case .BinaryOperation(let op,let operation):
                println("操作符：\(op)")
                println("操作数1：\(preOperand)")
                println("Stack:\(remainingOps)")
                let op1Evaluation = evaluate(0,ops: remainingOps)
                if let operand1 = op1Evaluation.result {
                    println("操作数2：\(operand1)")
                    return (operation(preOperand,operand1),op1Evaluation.remainingOps)
                }else{
                    println("Something happened,Operand:\(preOperand),Operator:\(op),Stack:\(op1Evaluation.remainingOps)")
                    return (0,op1Evaluation.remainingOps)
                }
            case .BracketOperation(")"):
                let op1Evaluation = evaluate(0,ops:remainingOps)
                println("endFlag:\(endFlag)")
                if let operand1 = op1Evaluation.result{
                    if !endFlag{
                        let op2Evaluation = evaluate(operand1,ops:op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result{
                            return (operand2,op2Evaluation.remainingOps)
                        }
                    }else{
                        return (operand1,[Op]())
                    }
                }
            case .BracketOperation("("):
                let op1Evaluation = evaluate(preOperand,ops:remainingOps)
                if let operand1 = op1Evaluation.result{
                    return (nil,remainingOps)
                }else{
                    endFlag = true
                    return (nil,remainingOps)
                }
            default:
                return (0,remainingOps)
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result,remainder) = evaluate(0,ops:opStack)
        println("\(opStack) = \(result) 加上剩下的 \(remainder)")
        return result
    }
    
    func pushOperand(operand:Double){
        opStack.append(Op.Operand(operand))
    }
    func pushOperation(symbol:String){
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
    }
    
    func performOperation(symbol:String)->Double?{
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    func removeAllOperand(){
        opStack.removeAll(keepCapacity: false)
    }
    func performEquals()->Double?{
        endFlag = false
        let result = evaluate()
        opStack.removeAll(keepCapacity: false)
        return result
    }
}