import SwiftUI

extension String {
    func chunked(by chunkSize: Int) -> [String] {
        stride(from: 0, to: self.count, by: chunkSize).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: chunkSize, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}

extension String {
    func leftPadding(toLength: Int, withPad: String) -> String {
        let padding = toLength - self.count
        if padding < 1 { return self }
        return String(repeating: withPad, count: padding) + self
    }
}

extension CalculatorButtonItem {
    func withDisabledState(numberBase: Int) -> CalculatorButtonItem {
        var isDisabled = self.isDisabled
        if ["A", "B", "C", "D", "E", "F", "#"].contains(self.title) {
            isDisabled = numberBase != 16
        } else if self.title == "." {
            isDisabled = numberBase != 10
        }
        return CalculatorButtonItem(
            title: self.title,
            backgroundColor: isDisabled ? .darkGray2 : self.backgroundColor,
            isDisabled: isDisabled
        )
    }
}

extension Color {
    static let darkGray = Color(white: 0.2)
    static let darkGray2 = Color(white: 0.5)
}
