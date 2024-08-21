import SwiftUI

struct CalculatorButton: View {
    var item: CalculatorButtonItem
    @Binding var highlightedKey: String?
    var action: () -> Void
    
    var body: some View {
        Button(action: handleButtonTap) {
            buttonContent
        }
        .buttonStyle(ClearBackgroundButtonStyle())
        .background(buttonBackground)
        .foregroundColor(buttonForeground)
        .cornerRadius(10)
        .disabled(item.isDisabled)
    }
    
    private func handleButtonTap() {
        guard !item.isDisabled else { return }
        action()
        highlightButtonTemporarily()
    }
    
    private func highlightButtonTemporarily() {
        highlightedKey = item.title
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            highlightedKey = nil
        }
    }
    
    private var buttonContent: some View {
        Text(item.title)
            .font(.system(size: 20))
            .frame(width: buttonWidth(), height: buttonHeight())
    }
    
    private var buttonBackground: Color {
        isHighlighted ? .blue.opacity(0.1) : .clear
    }
    
    private var buttonForeground: Color {
        if isHighlighted {
            return .blue.opacity(1.0)
        } else {
            return item.isDisabled ? .darkGray : item.backgroundColor
        }
    }
    
    private var isHighlighted: Bool {
        highlightedKey == item.title
    }
    
    private func buttonWidth() -> CGFloat {
        standardButtonWidth()
    }
    
    private func buttonHeight() -> CGFloat {
        standardButtonWidth()
    }
    
    private func standardButtonWidth() -> CGFloat {
        (300 - 5 * 12) / 4
    }
}
