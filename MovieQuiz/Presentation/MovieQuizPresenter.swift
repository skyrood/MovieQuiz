//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 19/07/2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresenterDelegate {
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticsService: StatisticsServiceProtocol!
    private var alertPresenter: AlertPresenterProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticsService = StatisticsService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        alertPresenter = AlertPresenter(delegate: self)
        
        self.loadDataForQuiz()
        self.viewController?.showLoadingIndicator()
    }

    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswers: Int = 0 //new
    
    private var currentQuestion: QuizQuestion?

    private func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func loadDataForQuiz() {
        questionFactory?.loadData()
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        viewController?.resetBorders()
    }
        
    private func switchToNextQuestion() {
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
    
    func noButtonClicked() {
        didAnswer(false)
    }
    
    func yesButtonClicked() {
        didAnswer(true)
    }
    
    private func didAnswer(_ answer: Bool) {
        viewController?.changeButtonsEnabledState(to: false)
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = answer
        let result = (givenAnswer == currentQuestion.correctAnswer)
        if result {
            correctAnswers += 1
        }
        proceedWithAnswer(isCorrect: result)
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
    
    private func proceedToNextQuestionOrPresentResults() {
        
        if self.isLastQuestion() {
            let currentGameResult = GameResult(correct: correctAnswers, total: self.questionsAmount, date: Date().dateTimeString)
            
            self.statisticsService.store(correct: currentGameResult.correct, total: currentGameResult.total)
        
            let result = String(currentGameResult.correct) + "/" + String(currentGameResult.total)
            
            let totalGamesCount = String((self.statisticsService.gamesCount))

            let record = "\(self.statisticsService.bestGame.correct)/\(self.statisticsService.bestGame.total) (\(self.statisticsService.bestGame.date))"
            
            var currentAccuracy: String = "146" // просто не придумал, что возвращать в случае ошибки
            
            currentAccuracy = String(format: "%.2f", self.statisticsService.totalAccuracy) + " %"
            
            let quizResult = AlertModel(
                title: "Раунд окончен",
                message: "Ваш результат: \(result),\nКоличество сыгранных квизов: \(totalGamesCount)\nРекорд: \(record)\nСредняя точность: \(currentAccuracy)",
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self else { return }
                    
                    self.resetQuiz()
                    self.questionFactory?.requestNextQuestion()
                }
                
            self.alertPresenter?.createAlert(with: quizResult)
            
        } else {
            viewController?.resetBorders()
            switchToNextQuestion()

            questionFactory?.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
        viewController?.changeButtonsEnabledState(to: true)
    }
    
    func didFailToLoadData(with error: Error) {
        self.presentNetworkErrorAlert(message: error.localizedDescription)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        self.viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController?.showLoadingIndicator()
            self.proceedToNextQuestionOrPresentResults()
        }
    }
    
    func presentAlert(alert: UIAlertController) {
        self.viewController?.showAlert(alert: alert)
    }
    
    private func presentNetworkErrorAlert(message: String) {
        self.viewController?.hideLoadingIndicator()
        
        let errorInfo = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.loadDataForQuiz()
            }
        
        self.alertPresenter?.createAlert(with: errorInfo)
    }
}
