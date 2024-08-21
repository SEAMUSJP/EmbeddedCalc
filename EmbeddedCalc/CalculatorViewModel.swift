import SwiftUI
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var display: String = "0"
    @Published var highlightedKey: String? = nil
    @Published var isPinned: Bool = false
    @Published var numberBase: Int = 10
    @Published var showBinaryWindow = false
    @Published var showFFConversionView = false

    private let validKeys = Set("0123456789abcdef.+-*/=\r")
    private let calculatorModel = CalculatorModel()
    private var isTypingNumber = false
    var keyboardMonitor: Any?

    func buttonTapped(_ button: String) {
        switch button {
        case "AC":
            resetCalculator()
        case "CL":
            clearDisplay()
        case "#":
            showBinaryWindow = true
        case "FF":
            showFFConversionView = true
        case "0"..."9", "A"..."F", "00":
            handleDigitInput(button)
        case ".":
            handleDecimalPointInput()
        case "+/-":
            toggleSign()
        case "+", "-", "*", "/":
            prepareForOperation(button)
        case "=":
            calculateResultAndUpdateDisplay()
        default:
            break
        }
    }
    
    func isButtonDisabled(_ button: String) -> Bool {
        if numberBase == 10 {
            return ["A", "B", "C", "D", "E", "F", "#"].contains(button)
        } else {
            return button == "."
        }
    }
    
    func togglePin() {
        isPinned.toggle()
    }
    
    func copyToPasteboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(display, forType: .string)
    }
    
    func pasteFromPasteboard() {
        if let pasteString = NSPasteboard.general.string(forType: .string) {
            display = pasteString
        }
    }
    
    func setupKeyboardHandling() {
        if let existingMonitor = keyboardMonitor {
            NSEvent.removeMonitor(existingMonitor)
        }

        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            self.handleKeyPress(event)
            return nil
        }

        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
            self.keyReleased(event)
            return nil
        }
    }
    
    func setWindowLevel() {
        if let window = NSApplication.shared.windows.first {
            window.level = isPinned ? .floating : .normal
        }
    }

    func convertDisplay(to base: Int) {
        switch base {
        case 16:
            guard var decimalValue = Decimal(string: display) else {
                display = "0"
                return
            }

            // 小数部分を切り捨て、整数部分を取得
            var integerValue = Decimal()
            NSDecimalRound(&integerValue, &decimalValue, 0, .down)

            // UInt64に変換可能な範囲かをチェックし、変換
            let intValue = NSDecimalNumber(decimal: integerValue).uint64Value
            display = String(format: "%016lX", intValue).uppercased()

        case 10:
            let hexString = display
            if let intValue = UInt64(hexString, radix: 16) {
                // 2の補数表現として解釈し、負の数を表示
                let signedValue = Int64(bitPattern: intValue)
                display = String(describing: Decimal(signedValue))
            } else {
                display = hexString
            }

        default:
            display = "0"
        }
    }

    func formattedDisplay() -> String {
        switch numberBase {
        case 16:
            if display == "Error: m + n exceeds 31" {
                return "Error: m + n exceeds 31"
            }

            let hexString = display.uppercased()
            let leadingZeroCount = hexString.prefix { $0 == "0" }.count
            let trimmedHexString = String(hexString.dropFirst(leadingZeroCount))
            return trimmedHexString.isEmpty ? "0x0" : "0x" + trimmedHexString
        default:
            return display
        }
    }
    
    private func resetCalculator() {
        display = "0"
        calculatorModel.resetCalculator()
        isTypingNumber = false
    }
    
    private func clearDisplay() {
        display = "0"
        isTypingNumber = false
    }
    
    private func handleDigitInput(_ digit: String) {
        let newDisplay = isTypingNumber ? (display == "0" ? digit : display + digit) : digit
        if willOverflow(newDisplay, radix: numberBase == 16 ? 16 : 10) {
            return
        }
        display = newDisplay
        isTypingNumber = true
    }
    
    private func handleDecimalPointInput() {
        if numberBase == 10 && !display.contains(".") {
            display.append(".")
            isTypingNumber = true
        }
    }
    
    private func toggleSign() {
        if numberBase == 16 {
            if let intValue = UInt64(display, radix: 16) {
                let twoComplementValue = (~intValue + 1) & 0xFFFFFFFFFFFFFFFF
                display = String(twoComplementValue, radix: 16).uppercased()
            }
        } else if let value = Decimal(string: display) {
            display = String(describing: value * -1)
        }
    }
    
    private func prepareForOperation(_ op: String) {
        calculatorModel.setPreviousNumber(calculatorModel.convertToDecimal(display, base: numberBase))
        calculatorModel.setOperation(op)
        isTypingNumber = false
    }

    private func calculateResultAndUpdateDisplay() {
        calculatorModel.setCurrentNumber(calculatorModel.convertToDecimal(display, base: numberBase))
        let result = calculatorModel.calculateResult()
        display = calculatorModel.formatResult(result, base: numberBase)
        isTypingNumber = false
    }
    
    private func willOverflow(_ value: String, radix: Int, maxValue: UInt64 = UInt64.max) -> Bool {
        if radix == 10 {
            if let decimalValue = Decimal(string: value), decimalValue <= Decimal(UInt64.max) {
                return false
            }
            return true
        } else {
            guard let intValue = UInt64(value.replacingOccurrences(of: "0x", with: ""), radix: radix) else {
                return true
            }
            return intValue > maxValue
        }
    }

    private func handleKeyPress(_ event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }
        for character in characters {
            let uppercasedCharacter = character.uppercased()

            // Command + 1で10進数ビュー
            if uppercasedCharacter == "1" && event.modifierFlags.contains(.command) {
                self.numberBase = 10
            }

            // Command + 2で16進数ビュー
            else if uppercasedCharacter == "2" && event.modifierFlags.contains(.command) {
                self.numberBase = 16
            }
            
            // Shift + FでFFボタン
            else if uppercasedCharacter == "F" && event.modifierFlags.contains(.shift) {
                highlightedKey = "FF"
                self.buttonTapped("FF")
            }
            
            // Shift + CでACボタン
            else if uppercasedCharacter.lowercased() == "c" && event.modifierFlags.contains(.shift) {
                highlightedKey = "AC"
                self.buttonTapped("AC")
            }

            // Command + Cでコピー
            else if uppercasedCharacter == "C" && event.modifierFlags.contains(.command) {
                self.copyToPasteboard()
            }

            // Command + Vでペースト
            else if uppercasedCharacter == "V" && event.modifierFlags.contains(.command) {
                self.pasteFromPasteboard()
            }
            
            // その他の有効キー処理
            else if validKeys.contains(character) && !self.isButtonDisabled(uppercasedCharacter) {
                highlightedKey = uppercasedCharacter == "\r" ? "=" : uppercasedCharacter
                if uppercasedCharacter == "\r" || uppercasedCharacter == "=" {
                    self.buttonTapped("=")
                } else {
                    self.buttonTapped(uppercasedCharacter)
                }
            }
            
            // Backspaceキー処理
            else if event.keyCode == 51 { // Backspace key
                self.handleBackspace()
            }
        }
    }
    
    private func keyReleased(_ event: NSEvent) {
        highlightedKey = nil
    }
    
    private func handleBackspace() {
        if (!display.isEmpty && display != "0") {
            display.removeLast()
            if display.isEmpty {
                display = "0"
                isTypingNumber = false
            }
        }
    }
}
