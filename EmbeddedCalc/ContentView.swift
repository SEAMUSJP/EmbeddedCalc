import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    let buttons: [[CalculatorButtonItem]] = [
        [CalculatorButtonItem(title: "A", backgroundColor: .gray),
         CalculatorButtonItem(title: "B", backgroundColor: .gray),
         CalculatorButtonItem(title: "C", backgroundColor: .gray),
         CalculatorButtonItem(title: "#", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "D", backgroundColor: .gray),
         CalculatorButtonItem(title: "E", backgroundColor: .gray),
         CalculatorButtonItem(title: "F", backgroundColor: .gray),
         CalculatorButtonItem(title: "FF", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "7", backgroundColor: .gray),
         CalculatorButtonItem(title: "8", backgroundColor: .gray),
         CalculatorButtonItem(title: "9", backgroundColor: .gray),
         CalculatorButtonItem(title: "/", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "4", backgroundColor: .gray),
         CalculatorButtonItem(title: "5", backgroundColor: .gray),
         CalculatorButtonItem(title: "6", backgroundColor: .gray),
         CalculatorButtonItem(title: "*", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "1", backgroundColor: .gray),
         CalculatorButtonItem(title: "2", backgroundColor: .gray),
         CalculatorButtonItem(title: "3", backgroundColor: .gray),
         CalculatorButtonItem(title: "-", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "0", backgroundColor: .gray),
         CalculatorButtonItem(title: "00", backgroundColor: .gray),
         CalculatorButtonItem(title: ".", backgroundColor: .gray, isDisabled: true),
         CalculatorButtonItem(title: "+", backgroundColor: .orange)],
        [CalculatorButtonItem(title: "AC", backgroundColor: .darkGray2),
         CalculatorButtonItem(title: "CL", backgroundColor: .darkGray2),
         CalculatorButtonItem(title: "+/-", backgroundColor: .darkGray2),
         CalculatorButtonItem(title: "=", backgroundColor: .orange)]
    ]

    var body: some View {
        VStack(spacing: 10) {
            displayOptions
            Spacer()
            displayText
            buttonGrid
        }
        .padding()
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .frame(width: 300, height: 500)
        .onAppear(perform: viewModel.setupKeyboardHandling)
        .onChange(of: viewModel.isPinned, perform: { _ in viewModel.setWindowLevel() })
        .onChange(of: viewModel.numberBase, perform: { _ in viewModel.convertDisplay(to: viewModel.numberBase) })
        .sheet(isPresented: $viewModel.showBinaryWindow) {
            BinaryView(display: $viewModel.display, viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showFFConversionView) {
            FFConversionView(display: $viewModel.display, numberBase: $viewModel.numberBase, onClose: {
                viewModel.setupKeyboardHandling()
            }, viewModel: viewModel)
        }
    }
    
    private var displayOptions: some View {
        HStack {
            numberBasePicker
            Spacer()
            pinButton
        }
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .topTrailing)
    }
    
    private var displayText: some View {
        Text(viewModel.formattedDisplay())
            .font(.system(size: 24).monospaced())
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
            .foregroundColor(.white)
            .contextMenu {
                copyPasteMenu
            }
    }

    private var buttonGrid: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row) { button in
                        CalculatorButton(item: button.withDisabledState(numberBase: viewModel.numberBase), highlightedKey: $viewModel.highlightedKey) {
                            viewModel.buttonTapped(button.title)
                        }
                    }
                }
            }
        }
    }
    
    private var numberBasePicker: some View {
        Picker("", selection: $viewModel.numberBase) {
            Text("10").tag(10)
            Text("16").tag(16)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 100)
    }
    
    private var pinButton: some View {
        Button(action: viewModel.togglePin) {
            Image(systemName: viewModel.isPinned ? "pin.fill" : "pin")
                .foregroundColor(viewModel.isPinned ? .green : .white)
        }
        .buttonStyle(PinButtonStyle())
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
    }
    
    private var copyPasteMenu: some View {
        Group {
            Button(action: viewModel.copyToPasteboard) {
                Text("コピー")
            }
            Button(action: viewModel.pasteFromPasteboard) {
                Text("ペースト")
            }
        }
    }
}
