//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 25/06/2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    func setDelegate(_ delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    // мок дата для квиза
    private var quizQuestions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    private var questionIndices: [Int] = []
    
    init() {
        self.resetIndices()
    }
    
    func resetIndices() {
        self.questionIndices = Array(0..<quizQuestions.count)
    }
    
    func requestNextQuestion() {
        
        guard let index = questionIndices.randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        questionIndices.removeAll { $0 == index }
        
        let question = quizQuestions[safe: index]
        
        delegate?.didReceiveNextQuestion(question: question)
    }
}
