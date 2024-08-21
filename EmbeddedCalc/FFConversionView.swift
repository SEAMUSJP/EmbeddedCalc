import SwiftUI

struct FFConversionView: View {
    @Binding var display: String
    @Binding var numberBase: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var mValue: String = ""
    @State private var nValue: String = ""
    let onClose: () -> Void
    let viewModel: CalculatorViewModel

    var body: some View {
        VStack {
            Text(numberBase == 10 ? "Float to Fixed convert" : "Fixed to Float convert")
                .font(.headline)
                .padding(.bottom)
            
            HStack {
                TextField("m", text: $mValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                
                TextField("n", text: $nValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
            }
            .padding(.leading)
            
            HStack {
                Button("OK") {
                    convertValue()
                }
                .buttonStyle(BorderedButtonStyle())
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(BorderedButtonStyle())
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            }
        }
        .padding()
        .frame(width: 400, height: 200)
        .onAppear {
            // キーボード入力の監視を停止
            if let monitor = viewModel.keyboardMonitor {
                NSEvent.removeMonitor(monitor)
                viewModel.keyboardMonitor = nil
            }

            // EnterキーでOKボタンを押す
            viewModel.keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 36 { // Enterキー
                    self.convertValue()
                    return nil
                }
                return event
            }
        }
        .onDisappear {
            onClose()
        }
    }
    
    private func convertValue() {
        guard let n = Int(mValue), let m = Int(nValue) else { return }
        
        // n + m が31でない場合、エラーを表示し、ビューを閉じる
        if m + n != 31 {
            display = "Error: m + n exceeds 31"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.presentationMode.wrappedValue.dismiss()
                self.onClose()
            }
            return
        }
        
        // 変換前にビューを閉じる
        presentationMode.wrappedValue.dismiss()
        onClose()

        if numberBase == 10 {
            // Float to Fixed conversion
            let decimalValue = Decimal(string: display) ?? 0
            let multiplier = pow(Decimal(2), m)
            let fixedPointValue = decimalValue * multiplier
            display = String(describing: fixedPointValue)
            numberBase = 16
        } else {
            // Fixed to Float conversion
            guard let intValue = UInt64(display, radix: 16) else {
                display = "0"
                return
            }
            let decimalValue = Decimal(intValue)
            let multiplier = pow(Decimal(2), m)
            let floatValue = decimalValue / multiplier
            display = String(describing: floatValue)
            numberBase = 10
        }
    }
}
