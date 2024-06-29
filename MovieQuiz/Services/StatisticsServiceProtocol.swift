//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 28/06/2024.
//

import Foundation

protocol StatisticsServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var correctCount: Int { get }
    
    func store(correct count: Int, total amount: Int)
}
