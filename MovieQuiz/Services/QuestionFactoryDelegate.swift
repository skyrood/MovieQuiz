//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 27/06/2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
