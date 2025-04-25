//
//  ContentView.swift
//  CombineAndDispatch
//
//  Created by 王昱淇 on 2025/4/25.
//

import SwiftUI

struct AlphabetChainView: View {
    @StateObject private var viewModel = AlphabetChainViewModel()
    @State private var userInput = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("字母接龍")
                .font(.largeTitle)

            Text("目前字母：\(viewModel.currentLetter)")
                .font(.title)

            TextField("請輸入下一個字母", text: $userInput, onCommit: {
                viewModel.submitAnswer(userInput)
                userInput = ""
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 200)

            Text(viewModel.message)
                .foregroundColor(.blue)

            Text("得分：\(viewModel.score)")
        }
        .padding()
    }
}

#Preview {
    AlphabetChainView()
}
