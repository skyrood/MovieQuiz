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
    
    var correctAnswers: Int = 0 //new
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    var questionFactory: QuestionFactoryProtocol?
    
    var alertPresenter: AlertPresenterProtocol?
    
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
        let result = (givenAnswer == currentQuestion.correctAnswer)
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
    
    //new
    // функция отображения результатов квиза либо следующего вопроса
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            // формирование и сохранение данных для результата
            let currentGameResult = GameResult(correct: correctAnswers, total: self.questionsAmount, date: Date().dateTimeString)
            
            self.viewController?.statisticsService?.store(correct: currentGameResult.correct, total: currentGameResult.total)
        
            let result = String(currentGameResult.correct) + "/" + String(currentGameResult.total)
            
            let totalGamesCount = String((self.viewController?.statisticsService?.gamesCount ?? 0))

            let record = "\(self.viewController?.statisticsService?.bestGame.correct ?? currentGameResult.correct)/\(self.viewController?.statisticsService?.bestGame.total ?? currentGameResult.total) (\(self.viewController?.statisticsService?.bestGame.date ?? "date not found"))"
            
            var currentAccuracy: String = "146" // просто не придумал, что возвращать в случае ошибки
            if let accuracy = self.viewController?.statisticsService?.totalAccuracy {
                currentAccuracy = String(format: "%.2f", accuracy) + " %"
            }

            let quizResult = AlertModel(
                title: "Раунд окончен",
                message: "Ваш результат: \(result),\nКоличество сыгранных квизов: \(totalGamesCount)\nРекорд: \(record)\nСредняя точность: \(currentAccuracy)",
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self else { return }
                    
                    self.viewController?.resetQuiz()
                    self.questionFactory?.requestNextQuestion()
                }
                
            // Выводим алерт
            self.alertPresenter?.show(quiz: quizResult)
            
        } else {
            viewController?.resetBorders()
            switchToNextQuestion()

            questionFactory?.requestNextQuestion()
        }
    }
}
