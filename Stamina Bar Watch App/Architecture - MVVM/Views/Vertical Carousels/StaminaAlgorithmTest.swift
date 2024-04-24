//
//  StaminaAlgorithmTest.swift
//  Stamina Bar Watch AppTests
//
//  Created by Bryce Ellis on 4/23/24.
//

import XCTest
import SwiftUI
@testable import Stamina_Bar_Watch_App

final class StaminaAlgorithmTest: XCTestCase {

    var staminaBarView: StaminaBarView! // Assuming this is the class containing the stressFunction

    override func setUpWithError() throws {
        super.setUpWithError()
        staminaBarView = StaminaBarView() // Ensure this class is initialized here
    }

    override func tearDownWithError() throws {
        staminaBarView = nil
        super.tearDownWithError()
    }

    func testStressFunctionWithNegativeHeartRate() throws {
        let result = staminaBarView.stressFunction(heart_rate: -1)
        if let text = (result as? Text) {
            XCTAssertEqual(text, Text("Loading"))
        } else {
            XCTFail("Expected a Text view containing 'Loading'")
        }
    }

    func testStressFunctionWithHeartRateInZone1() throws {
        let result = staminaBarView.stressFunction(heart_rate: 50)
        if let text = (result as? Text) {
            XCTAssertEqual(text, Text("100"))
        } else {
            XCTFail("Expected a Text view containing '100'")
        }
    }

    func testStressFunctionWithHeartRateInZone2() throws {
        let result = staminaBarView.stressFunction(heart_rate: 62)
        if let text = (result as? Text) {
            XCTAssertEqual(text, Text("99"))
        } else {
            XCTFail("Expected a Text view containing '99'")
        }
    }
}
