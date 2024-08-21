import SwiftUI

struct CalculatorButtonItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let backgroundColor: Color
    var isDisabled: Bool = false
}
