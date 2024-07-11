//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 26/06/2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func resetIndices()
    func loadData()
}
