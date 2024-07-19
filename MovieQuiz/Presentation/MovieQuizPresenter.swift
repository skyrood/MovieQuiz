//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 19/07/2024.
//

import UIKit

final class MovieQuizPresenter {
    // инициализация номера вопроса и количества правильных ответов
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: currentQuestionIndex,
            questionsAmount: questionsAmount
        )
    }
    
    // обработчик нажатия на кнопку НЕТ
    func noButtonClicked() {
        didAnswer(false)
    }
    
    // обработчик нажания на кнопку ДА
    func yesButtonClicked() {
        didAnswer(true)
    }
    
    private func didAnswer(_ answer: Bool) {
        viewController?.changeButtonsEnabledState(to: false)
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = answer
        let result = (answer == currentQuestion.correctAnswer)
        viewController?.showAnswerResult(isCorrect: result)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.changeButtonsEnabledState(to: true)
            self?.viewController?.hideLoadingIndicator()
        }
    }
}
