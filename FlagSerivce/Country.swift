//
//  Country.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/11/24.
//

import Foundation
import SwiftUI

class Country: Codable, Identifiable {
    let emoji: String
    let name: String
    
    
    init(emoji: String, name: String) {
        self.emoji = emoji
        self.name = name
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        emoji = try container.decode(String.self, forKey: .emoji)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(name, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case emoji
        case name
    }
}

