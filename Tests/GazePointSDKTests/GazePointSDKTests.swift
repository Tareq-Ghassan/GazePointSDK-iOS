import XCTest
@testable import GazePointSDK

final class GazePointSDKTests: XCTestCase {
    func testVersion() {
        XCTAssertFalse(GazePointSDK.version.isEmpty)
    }
}
