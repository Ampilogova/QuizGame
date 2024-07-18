//
//  MenuSwiftUIView.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/17/24.
//

import SwiftUI

struct MenuSwiftUIView: View {
    
    let flagService: FlagService
    @State private var selectedLevel: DifficultyLevel?
    
    var body: some View {
        NavigationStack {
            chooseComplexityButton
        }
    }
    
    @ViewBuilder var chooseComplexityButton: some View {
        VStack {
            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                NavigationLink(destination: GameSwiftUIView(flagService: flagService, difficultyLevel: level)) {
                    Text(level.title)
                        .font(.body)
                        .padding()
                        .frame(width: 180, height: 80)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}
