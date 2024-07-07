//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 27/06/2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: () -> Void
}
