//
//  Localization.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 06/08/2024.
//

import Foundation

class Localization {
    static func localizedString(forKey key: String, comment: String = "") -> String {
        return NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: "", comment: comment)
    }
}
