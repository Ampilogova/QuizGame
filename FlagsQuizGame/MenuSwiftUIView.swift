//
//  MenuSwiftUIView.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/17/24.
//

import SwiftUI

struct MenuSwiftUIView: View {
    
    var body: some View {
        chooseComplexityButton
    }
    
    @ViewBuilder var chooseComplexityButton: some View {
        VStack {
            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                Button {
                    //To do something
                } label: {
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
