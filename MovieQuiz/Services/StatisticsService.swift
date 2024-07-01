//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 28/06/2024.
//

import Foundation

class StatisticsService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case bestGameTotal
        case bestGameCorrect
        case bestGameDate
        case gamesCount
        case correctCount
    }
}

extension StatisticsService: StatisticsServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correctCount: Int {
        get {
            return storage.integer(forKey: Keys.correctCount.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.correctCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue)
            
            return GameResult(correct: correct, total: total, date: date as? String ?? Date().dateTimeString)
        }
        
        set {
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(Date().dateTimeString, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if (self.gamesCount > 0) {
            return Double(self.correctCount * 10) / Double(self.gamesCount)
        } else {
            return 146 // просто не придумал, что возвращать в случае ошибки
        }
    }
    
    func store(correct count: Int, total amount: Int) {        
        self.gamesCount += 1
        self.correctCount += count
        
        let currentResult: GameResult = GameResult(correct: count, total: amount, date: Date().dateTimeString)
        
        if currentResult.isBetter(than: bestGame) {
            bestGame = currentResult
        }
    }
}
