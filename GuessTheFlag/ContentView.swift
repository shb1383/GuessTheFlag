//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Syrene Haber Bartolome on 2024/09/20.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var userScore = 0
    @State private var questions = 0
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacities = [1.0, 1.0, 1.0]
    @State private var scales = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                                .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                                .opacity(opacities[number])
                                .scaleEffect(scales[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(questions < 8 ? "Continue" : "Restart", action: questions < 8 ? askQuestion : reset)
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            animationAmount[number] += 360
            
            for index in 0..<3 {
                opacities[index] = index == number ? 1.0 : 0.25
                scales[index] = index == number ? 1.0 : 0.75
            }
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        questions += 1
                
        if questions >= 8 {
            scoreMessage = "You got \(userScore) out of \(questions) questions correct!"
        } else {
            scoreMessage = "Your score is \(userScore)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacities = [1.0, 1.0, 1.0]
        scales = [1.0, 1.0, 1.0]
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        userScore = 0
        questions = 0
        opacities = [1.0, 1.0, 1.0]
        scales = [1.0, 1.0, 1.0]
    }
}

#Preview {
    ContentView()
}
