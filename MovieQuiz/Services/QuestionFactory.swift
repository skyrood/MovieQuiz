//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 25/06/2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    
    private var movies: [MostPopularMovie] = []
    
    private var questionIndices: [Int] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // сброс массива индексов к дефолтному состоянию
    func resetIndices() {
        self.questionIndices = Array(0..<self.movies.count)
    }
    
    // загрузка данных
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.resetIndices()
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // формирование данных для вопроса
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = self.questionIndices.randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            var text: String = ""
            var correctAnswer: Bool = false
            
            // генератор случайных вариантов вопроса
            let lowerRating = Int(floor(rating))
            let upperRating = Int(ceil(rating))
            
            let questionGreaterThan = Localization.localizedString(forKey: "questionGreaterThan")
            let questionLessThan = Localization.localizedString(forKey: "questionLessThan")
            
            if lowerRating != upperRating {
                let questionRating = Bool.random() ? lowerRating : upperRating
                Bool.random() ? (text = String(format: questionGreaterThan, questionRating), correctAnswer = rating > Float(questionRating)) : (text = String(format: questionLessThan, questionRating), correctAnswer = rating < Float(questionRating))
            } else {
                let questionRating = rating - 1
                Bool.random() ? (text = String(format: questionLessThan, Int(questionRating)), correctAnswer = false) : (text = String(format: questionGreaterThan, Int(questionRating)), correctAnswer = true)
            }
            // конец генератора

            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            self.questionIndices.removeAll { $0 == index }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
