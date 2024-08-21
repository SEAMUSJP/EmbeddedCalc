import Foundation

class CalculatorModel {
    private(set) var previousNumber: Decimal = 0
    private(set) var currentNumber: Decimal = 0
    private(set) var operation: String = ""
    
    func resetCalculator() {
        previousNumber = 0
        currentNumber = 0
        operation = ""
    }
    
    func setOperation(_ op: String) {
        operation = op
    }
    
    func setPreviousNumber(_ number: Decimal) {
        previousNumber = number
    }
    
    func setCurrentNumber(_ number: Decimal) {
        currentNumber = number
    }

    
    func calculateResult() -> Decimal {
        switch operation {
        case "+":
            return previousNumber + currentNumber
        case "-":
            return previousNumber - currentNumber
        case "*":
            return previousNumber * currentNumber
        case "/":
            return previousNumber / currentNumber
        default:
            return currentNumber
        }
    }
    
    func convertToDecimal(_ value: String, base: Int) -> Decimal {
        if base == 16, let intValue = Int64(value, radix: 16) {
            return Decimal(intValue)
        } else if base == 10, let decimalValue = Decimal(string: value) {
            return decimalValue
        }
        return 0
    }
    
    func formatResult(_ value: Decimal, base: Int) -> String {
        if base == 16 {
            let intValue = NSDecimalNumber(decimal: value).uint64Value
            return String(format: "%016lX", intValue).uppercased()
        } else {
            return String(describing: value)
        }
    }
}
