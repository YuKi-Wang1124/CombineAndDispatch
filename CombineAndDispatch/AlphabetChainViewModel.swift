//
//  File.swift
//  ReactionTimerViewModel
//
//  Created by 王昱淇 on 2025/4/25.
//

import Foundation
import Combine

class AlphabetChainViewModel: ObservableObject {
    @Published var currentLetter: String = ""
    @Published var message: String = "準備開始遊戲"
    @Published var score: Int = 0

    private var questionLetter = CurrentValueSubject<String, Never>("")
    private var answerSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        answerSubject
            .combineLatest(questionLetter)
            .sink { [weak self] answer, question in
                guard let self else { return }

                let expected = Self.nextLetter(after: question)
                if answer.uppercased() == expected {
                    self.message = "答對了！正確是 \(expected)"
                    self.score += 1
                    self.askNewQuestion()
                } else {
                    self.message = "錯了！應該是 \(expected)"
                    self.score = 0
                }
            }
            .store(in: &cancellables)

        askNewQuestion()
    }

    func submitAnswer(_ letter: String) {
        answerSubject.send(letter)
    }

    func askNewQuestion() {
        let newLetter = String((65...89).randomElement().map { Character(UnicodeScalar($0)) }!)
        questionLetter.send(newLetter)
        currentLetter = newLetter
    }

    private static func nextLetter(after letter: String) -> String {
        guard let ascii = letter.uppercased().unicodeScalars.first?.value else { return "" }
        let next = ascii == 90 ? 65 : ascii + 1  // Z -> A
        return String(UnicodeScalar(next)!)
    }
}
