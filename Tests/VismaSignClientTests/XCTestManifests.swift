import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NetworkingTests.allTests),
        testCase(UtilityTests.allTests),
        testCase(SecurityTests.allTests),
    ]
}
#endif