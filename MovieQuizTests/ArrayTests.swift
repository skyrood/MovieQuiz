//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Rodion Kim on 21/07/2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]

        // When
        let value = array[safe: 20]

        // Then
        XCTAssertNil(value)
    }
}
