//
//  DifficultyLevel.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/17/24.
//

import Foundation

enum DifficultyLevel: CaseIterable {
    case easy
    case medium
    case hard
    
    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}