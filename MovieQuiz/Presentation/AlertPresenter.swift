//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 27/06/2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func setDelegate(_ delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }

    func show(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        
        delegate?.presentAlert(alert: alert)
    }
}