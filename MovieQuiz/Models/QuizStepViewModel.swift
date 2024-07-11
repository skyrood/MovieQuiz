//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 25/06/2024.
//

import UIKit

// модель вопроса
struct QuizStepViewModel {
    let image: UIImage?
    let question: String
    let questionNumber: String
    
    init(image: Data, question: String, questionNumber: Int, questionsAmount: Int) {
        self.image = UIImage(data: image) ?? UIImage()
        self.question = question
        self.questionNumber = String(questionNumber + 1) + "/" + String(questionsAmount)
    }
}
