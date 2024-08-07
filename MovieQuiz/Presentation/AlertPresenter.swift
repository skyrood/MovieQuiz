//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 27/06/2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }

    func createAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "completionAlert"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        delegate?.presentAlert(alert: alert)
    }
}
