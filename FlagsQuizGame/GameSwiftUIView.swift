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
    @State private var selectedOption: Country?
    @State private var options: [Country] = []
    @State private var score: Int = 0
    @State private var answerSubmitted: Bool = false
    private var flagService: FlagService

    init(flagService: FlagService) {
        self.flagService = flagService
    }

    var body: some View {
        VStack {
            Text(currentCountry?.emoji ?? "")
                .lineLimit(2)
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
                    self.selectedOption = country
                    self.checkAnswer(country: country)
                }) {
                    Text(country.name)
                        .font(.body)
                        .padding()
                        .frame(width: 180, height: 80)
                        .background(self.buttonColor(for: country))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 5)
            }
        }
    }

    private func checkAnswer(country: Country) {
        if answerSubmitted { return }

        answerSubmitted = true

        if country.id == currentCountry?.id {
            score += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextQuestion()
        }
    }

    private func buttonColor(for country: Country) -> Color {
        if answerSubmitted {
            if country.id == selectedOption?.id {
                return country.id == currentCountry?.id ? .green : .red
            }
        }
        return .blue
    }

    private func sendRequest() async {
        do {
            let countries = try await flagService.sendRequest()
            self.countries = countries
            if let firstCountry = countries.randomElement() {
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
        answerSubmitted = false
        if let newCountry = countries.randomElement() {
            currentCountry = newCountry
            generateOptions(correctCountry: newCountry)
        }
    }
}

