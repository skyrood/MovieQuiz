//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 21/07/2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func resetBorders()
    
    func show(quiz step: QuizStepViewModel)
    func showAlert(alert: UIAlertController)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func changeButtonsEnabledState(to status: Bool)
}
