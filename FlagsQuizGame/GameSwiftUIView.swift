//
//  GameSwiftUIView.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/11/24.
//

import SwiftUI

struct GameSwiftUIView: View {
    
    @State private var countries: [Country] = []
    
    @State private var currentCountry: Country?
    @State private var options: [Country] = []
    @State private var score: Int = 0
    private var flagService: FlagService
    
    init(flagService: FlagService) {
        self.flagService = flagService
    }
    
    var body: some View {
        VStack {
            Text(currentCountry?.emoji ?? "")
                .font(.system(size: 200))
                .padding()
            
            HStack(spacing: 10) {
                Spacer()
                buttonStack(for: Array(options.prefix(2)))
                buttonStack(for: Array(options.suffix(2)))
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Text("Score: \(score)")
                .font(.title2)
                .padding(.top)
        }
        .task {
            await sendRequest()
        }
    }
    
    private func buttonStack(for countries: [Country]) -> some View {
        VStack(spacing: 5) {
            ForEach(countries) { country in
                Button(action: {
                    self.checkAnswer(country: country)
                }) {
                    Text(country.name)
                        .font(.body)
                        .padding()
                        .frame(width: 180, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 5)
            }
        }
    }
    
    
    private func checkAnswer(country: Country) {
        if country.id == currentCountry?.id {
            score += 1
        } else {
            score -= 1
        }
        nextQuestion()
    }
    
    private func sendRequest() async {
        do {
            let countries = try await flagService.sendRequest()
            self.countries = countries
            if let firstCountry = countries.first {
                self.currentCountry = firstCountry
                generateOptions(correctCountry: firstCountry)
            }
        } catch {
            print("Failed to send request: \(error)")
        }
    }
    
    private func generateOptions(correctCountry: Country) {
        var tempOptions = countries.shuffled().prefix(3)
        
        if !tempOptions.contains(where: { $0.id == correctCountry.id }) {
            tempOptions.append(correctCountry)
        }
        
        options = Array(tempOptions).shuffled()
    }
    
    private func nextQuestion() {
        if let newCountry = countries.randomElement() {
            currentCountry = newCountry
            generateOptions(correctCountry: newCountry)
        }
    }
}
