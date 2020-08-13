//
//  ContentView.swift
//  WordScramble
//
//  Created by Paul Houghton on 10/08/2020.
//  Copyright © 2020 Paul Houghton. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                List(usedWords, id: \.self) { word in
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                }
                Spacer()
                HStack {
                    Text("Score")
                    Text("\(score)")
                }
                .padding()
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(
                leading: Button(action: startGame) {
                    Text("Restart")
                }
            )
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
//        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//            // we found the file in our bundle
//
//            if let fileContents = try? String(contentsOf: fileURL) {
//                // we loaded the file into a string
//            }
//        }
        
//        let input = "a b c"
//        let letters = input.components(separatedBy: " ")
        
//        let input = """
//                    a
//                    b
//                    c
//                    """
//        let letters = input.components(separatedBy: "\n")
//
//        let letter = letters.randomElement()
//        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        let word = "swift"
//        let checker = UITextChecker()
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//
//        let allGood = misspelledRange.location == NSNotFound
        
//        return Text("Hello, world!")
        
//        List {
//            Section(header: Text("Section 1")) {
//                Text("Static row 1")
//                Text("Static row 2")
//            }
//            Section(header: Text("Section 2")) {
//                ForEach(0..<5) { number in
//                    Text("Dynamic row \(number)" )
//                }
//            }
//            Section(header: Text("Section 3")) {
//                Text("Static row 3")
//                Text("Static row 4")
//            }
//        }
//        .listStyle(GroupedListStyle())
  
//        List(0..<5) { number in
//            Text("Dynamic row \(number)")
//        }
        
//        List(people, id: \.self) { name in
//            Text(name)
//        }
        
//        List {
//            ForEach(people, id: \.self) {
//                Text($0)
//            }
//        }
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        // Validation
        guard isNotRootWord(word: answer) else {
            wordError(title: "Word is the root word", message: "You're just not trying.")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Too short", message: "Words should be at least 3 letters long.")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "Use only the available letters.")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Word not recognised", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        updateScore(answer: answer)
        newWord = ""
    }
    
    func updateScore(answer: String) {
        let answerScore = answer.count
        score += answerScore
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = [String]()
                score = 0
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func isRealWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isNotRootWord(word: String) -> Bool {
        return !(word == rootWord)
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
