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
}
