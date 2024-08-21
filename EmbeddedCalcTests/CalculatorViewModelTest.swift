import XCTest
@testable import EmbeddedCalc

final class CalculatorViewModelTests: XCTestCase {

    var viewModel: CalculatorViewModel!

    override func setUpWithError() throws {
        viewModel = CalculatorViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitialDisplayValue() throws {
        XCTAssertEqual(viewModel.display, "0", "Initial display value should be 0")
    }

    func testButtonTappedDigit() throws {
        viewModel.buttonTapped("1")
        XCTAssertEqual(viewModel.display, "1", "Display should show 1 after '1' button is tapped")

        viewModel.buttonTapped("2")
        XCTAssertEqual(viewModel.display, "12", "Display should show 12 after '2' button is tapped")
    }

    func testButtonTappedAddition() throws {
        viewModel.buttonTapped("1")
        viewModel.buttonTapped("+")
        viewModel.buttonTapped("2")
        viewModel.buttonTapped("=")
        XCTAssertEqual(viewModel.display, "3", "1 + 2 should equal 3")
    }

    func testButtonTappedClear() throws {
        viewModel.buttonTapped("1")
        viewModel.buttonTapped("CL")
        XCTAssertEqual(viewModel.display, "0", "Display should be reset to 0 after 'C' button is tapped")
    }

    func testButtonTappedToggleSign() throws {
        viewModel.buttonTapped("1")
        viewModel.buttonTapped("+/-")
        XCTAssertEqual(viewModel.display, "-1", "Display should show -1 after '+/-' button is tapped")

        viewModel.buttonTapped("+/-")
        XCTAssertEqual(viewModel.display, "1", "Display should show 1 after '+/-' button is tapped again")
    }

    func testButtonTappedReset() throws {
        viewModel.buttonTapped("1")
        viewModel.buttonTapped("+")
        viewModel.buttonTapped("2")
        viewModel.buttonTapped("AC")
        XCTAssertEqual(viewModel.display, "0", "Display should be reset to 0 after 'AC' button is tapped")
    }
}
