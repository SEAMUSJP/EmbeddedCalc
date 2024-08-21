import XCTest
@testable import EmbeddedCalc

final class CalculatorModelTests: XCTestCase {

    var calculator: CalculatorModel!

    override func setUpWithError() throws {
        // テストのセットアップ
        calculator = CalculatorModel()
    }

    override func tearDownWithError() throws {
        // テストの後処理
        calculator = nil
    }

    func testAddition() throws {
        calculator.setPreviousNumber(Decimal(10))
        calculator.setCurrentNumber(Decimal(20))
        calculator.setOperation("+")
        let result = calculator.calculateResult()
        XCTAssertEqual(result, Decimal(30), "10 + 20 should equal 30")
    }

    func testSubtraction() throws {
        calculator.setPreviousNumber(Decimal(30))
        calculator.setCurrentNumber(Decimal(10))
        calculator.setOperation("-")
        let result = calculator.calculateResult()
        XCTAssertEqual(result, Decimal(20), "30 - 10 should equal 20")
    }

    func testMultiplication() throws {
        calculator.setPreviousNumber(Decimal(5))
        calculator.setCurrentNumber(Decimal(4))
        calculator.setOperation("*")
        let result = calculator.calculateResult()
        XCTAssertEqual(result, Decimal(20), "5 * 4 should equal 20")
    }

    func testDivision() throws {
        calculator.setPreviousNumber(Decimal(20))
        calculator.setCurrentNumber(Decimal(4))
        calculator.setOperation("/")
        let result = calculator.calculateResult()
        XCTAssertEqual(result, Decimal(5), "20 / 4 should equal 5")
    }

    func testDivisionByZero() throws {
        calculator.setPreviousNumber(Decimal(20))
        calculator.setCurrentNumber(Decimal(0))
        calculator.setOperation("/")
        let result = calculator.calculateResult()
        XCTAssertTrue(result.isNaN, "Division by zero should result in NaN")
    }

    func testResetCalculator() throws {
        calculator.setPreviousNumber(Decimal(20))
        calculator.setCurrentNumber(Decimal(10))
        calculator.setOperation("+")
        calculator.resetCalculator()

        XCTAssertEqual(calculator.previousNumber, Decimal(0), "Previous number should be reset to 0")
        XCTAssertEqual(calculator.currentNumber, Decimal(0), "Current number should be reset to 0")
        XCTAssertEqual(calculator.operation, "", "Operation should be reset to empty string")
    }
}
