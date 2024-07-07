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
    
    init(imageName: String, question: String, questionNumber: Int) {
        self.image = UIImage(named: imageName) ?? UIImage()
        self.question = question
        self.questionNumber = String(questionNumber + 1) + "/10"
    }
}
