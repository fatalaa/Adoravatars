import XCTest
@testable import Adoravatars

class AvatarNameMappingTests: XCTestCase {
    
    func testBadUrlInput() {
        guard let nameMapper = AvatarNameMapper(with: "https://api.adorable.io/avatars////////", imageSize: 100) else {
            XCTFail("Failed to create AvatarNameMapper instance")
            return
        }
        
        let inputName = "Boba Fett"
        
        guard let expectedResult = URL(string: "https://api.adorable.io/avatars/100/Boba%20Fett.png")?.absoluteString else {
            XCTFail("Invalid url we have here")
            return
        }
        XCTAssert(expectedResult.elementsEqual(nameMapper.map(from: inputName).absoluteString))
    }
    
    func testNormalUrlInput() {
        guard let nameMapper = AvatarNameMapper(with: "https://api.adorable.io/avatars", imageSize: 100) else {
            XCTFail("Failed to create AvatarNameMapper instance")
            return
        }
        let inputName = "Boba Fett"
        guard let expectedResult = URL(string: "https://api.adorable.io/avatars/100/Boba%20Fett.png")?.absoluteString else {
            XCTFail("Invalid url we have here")
            return
        }
        XCTAssert(expectedResult.elementsEqual(nameMapper.map(from: inputName).absoluteString))
    }
}
