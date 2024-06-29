//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 28/06/2024.
//

import Foundation

// модель результата раунда
struct GameResult {
    let correct: Int
    let total: Int
    let date: String
    
    func isBetter(than oldResult: GameResult) -> Bool {
        correct >= oldResult.correct
    }
}
