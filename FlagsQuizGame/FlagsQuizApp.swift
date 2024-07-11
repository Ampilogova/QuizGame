//
//  FlagsQuizApp.swift
//  FlagsQuizGame
//
//  Created by Tatiana Ampilogova on 7/11/24.
//

import SwiftUI

@main
struct FlagsQuizApp: App {
    var body: some Scene {
        WindowGroup {
            GameSwiftUIView(flagService: FlagServiceImpl(networkService: NetworkServiceImpl()))
        }
    }
}
