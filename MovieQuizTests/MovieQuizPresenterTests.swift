//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Rodion Kim on 21/07/2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func resetBorders() {
        
    }
    
    func changeButtonsEnabledState(to status: Bool) {
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {
    
    }
    
    func showAlert(alert: UIAlertController) {
    
    }
    
    func highlightImageBorder(isCorrect: Bool) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "QuestionText", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "QuestionText")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
