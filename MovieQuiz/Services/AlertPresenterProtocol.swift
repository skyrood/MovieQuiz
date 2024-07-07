//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 27/06/2024.
//

import Foundation

protocol AlertPresenterProtocol {    
    func setDelegate(_ delegate: AlertPresenterDelegate)
    
    func show(quiz result: AlertModel)
}
