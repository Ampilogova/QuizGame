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
    @State private var country: String = ""
    private var flagService: FlagService
    var difficultyLevel: DifficultyLevel

    init(flagService: FlagService, difficultyLevel: DifficultyLevel) {
        self.flagService = flagService
        self.difficultyLevel = difficultyLevel
    }

    var body: some View {
        VStack {
            Text(currentCountry?.emoji ?? "")
                .lineLimit(2)
                .font(.system(size: 200))
                .padding()

            HStack(spacing: 10) {
                switch difficultyLevel {
                case .easy:
                    Spacer()
                    buttonStack(for: Array(options.prefix(DifficultyLevel.easy.level / 2)))
                    buttonStack(for: Array(options.suffix(DifficultyLevel.easy.level / 2)))
                    Spacer()
                case .medium:
                    Spacer()
                    buttonStack(for: Array(options.prefix(DifficultyLevel.medium.level / 2)))
                    buttonStack(for: Array(options.suffix(DifficultyLevel.medium.level / 2)))
                    Spacer()
                case .hard:
                    HStack {
                        Spacer()
                        TextField("Enter the country name", text: $country, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            checkAnswer(country: Country(emoji: "", name: country))
                        } label: {
                            Text("Send")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10) // Add horizontal padding
                                .padding(.vertical, 5)   // Add vertical padding
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
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
                generateOptions(difficultyLevel: difficultyLevel, correctCountry: firstCountry)
            }
        } catch {
            print("Failed to send request: \(error)")
        }
    }

    private func generateOptions(difficultyLevel: DifficultyLevel, correctCountry: Country) {
        var tempOptions = countries.shuffled().prefix(difficultyLevel.level)

        if !tempOptions.contains(where: { $0.id == correctCountry.id }) {
            tempOptions.append(correctCountry)
        }

        options = Array(tempOptions).shuffled()
    }

    private func nextQuestion() {
        answerSubmitted = false
        if let newCountry = countries.randomElement() {
            currentCountry = newCountry
            generateOptions(difficultyLevel: difficultyLevel, correctCountry: newCountry)
        }
    }
}

