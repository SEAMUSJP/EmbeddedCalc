import SwiftUI

struct BinaryView: View {
    @Binding var display: String
    @Environment(\.presentationMode) var presentationMode
    let viewModel: CalculatorViewModel  // viewModelを追加

    var body: some View {
        let binaryStrings = binaryRepresentation()

        VStack {
            ForEach(binaryStrings, id: \.self) { line in
                Text(line)
                    .font(.system(size: 14).monospaced())
                    .contextMenu {
                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(binaryStrings.joined(separator: "\n"), forType: .string)
                        }) {
                            Text("コピー")
                        }
                    }
            }
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 400, height: 200)
        .onAppear {
            // キーボード入力の監視を停止
            if let monitor = viewModel.keyboardMonitor {
                NSEvent.removeMonitor(monitor)
                viewModel.keyboardMonitor = nil
            }
        }
        .onDisappear {
            presentationMode.wrappedValue.dismiss()
            viewModel.setupKeyboardHandling()
        }
    }

    private func binaryRepresentation() -> [String] {
        let hexString = display
        guard let number = UInt64(hexString, radix: 16) else { return ["Invalid input"] }
        let binaryString = String(number, radix: 2).leftPadding(toLength: 64, withPad: "0")
        let chunkedBinaryString = binaryString.chunked(by: 4)

        return [
            chunkedBinaryString.prefix(8).joined(separator: " "),
            chunkedBinaryString.dropFirst(8).prefix(8).joined(separator: " "),
            chunkedBinaryString.dropFirst(16).prefix(8).joined(separator: " "),
            chunkedBinaryString.dropFirst(24).prefix(8).joined(separator: " ")
        ]
    }
}
