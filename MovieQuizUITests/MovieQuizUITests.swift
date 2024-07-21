//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Rodion Kim on 21/07/2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
            
        sleep(3)
                
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let label = app.staticTexts["Index"]
                
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(label.label, "2/10")
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let firstLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(firstLabel.label, "1/10")
        
        sleep(3)
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let secondLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(secondLabel.label, "2/10")
    }
    
    func testAlertOnCompletion() {
        sleep(5)
        
        for _ in 1...10 {
            sleep(3)
            app.buttons["Yes"].tap()
        }
        
        sleep(3)
                
        let alert = app.alerts["completionAlert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Раунд окончен")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertHide() {
        sleep(5)

        for _ in 1...10 {
            sleep(3)
            app.buttons["Yes"].tap()
        }
        
        let alert = app.alerts["completionAlert"]
        
        alert.buttons.firstMatch.tap()

        sleep(3)
        
        let label = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(label.label, "1/10")
    }
}

