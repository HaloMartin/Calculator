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
    
    init(){
        knowOps["×"] = Op.BinaryOperation("×",*)
        knowOps["÷"] = Op.BinaryOperation("÷"){$1/$0}
        knowOps["+"] = Op.BinaryOperation("+",+)
        knowOps["-"] = Op.BinaryOperation("-"){$1-$0}
        knowOps["√"] = Op.UnaryOperation("√",sqrt)
        knowOps["("] = Op.BracketOperation("(")
        knowOps[")"] = Op.BracketOperation(")")
    }
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            case .BracketOperation(_):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    return (operand1,op1Evaluation.remainingOps)
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result,remainder) = evaluate(opStack)
        println("\(opStack) = \(result) 加上剩下的 \(remainder)")
        return result
    }
    
    func pushOperand(operand:Double)->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
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
}