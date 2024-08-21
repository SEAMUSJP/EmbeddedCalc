import SwiftUI

struct ClearBackgroundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.clear)
            .padding(.horizontal, -20)
            .padding(.vertical, -30)
            .contentShape(Rectangle())
    }
}

struct PinButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.clear)
            .padding(.horizontal, -10)
            .padding(.vertical, -10)
            .contentShape(Rectangle())
    }
}
