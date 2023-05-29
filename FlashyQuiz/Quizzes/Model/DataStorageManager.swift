//
//  DataStorageManager.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 21/5/2023.
//

import Foundation

class DataStorageManager {
    
    //This was my textfile data mangaer. Allowed me to added and view quizzes as that was inital scope.
   /** // Function to get the project's root directory
    func getProjectRootDirectory() -> URL? {
        let currentFileURL = URL(fileURLWithPath: #file)
        let projectRootURL = currentFileURL
            .deletingLastPathComponent() // Remove the current file's path component
            .deletingLastPathComponent() // Remove the current file's containing folder path component
            .deletingLastPathComponent() // Remove the "Sources" folder path component
        return projectRootURL
    }
    
    // Function to save the Quiz objects to a text file
    func saveToFile(_ quizzes: [Quiz]) {
        if let projectRootURL = getProjectRootDirectory() {
            let textFileFolderURL = projectRootURL.appendingPathComponent("Quizzes/Data")
            let fileURL = textFileFolderURL.appendingPathComponent("quiz.txt")
            
            let fileManager = FileManager.default
            do {
                try fileManager.createDirectory(at: textFileFolderURL, withIntermediateDirectories: true, attributes: nil)
                
                let filteredLines = filterExistingQuizzes(in: fileURL, quizzes: quizzes)
                writeToFile(fileURL: fileURL, lines: filteredLines + quizzes)
                
                print("Quizzes saved to file: \(fileURL.path)")
            } catch {
                print("Error saving quizzes to file: \(error)")
            }
        }
    }

    func filterExistingQuizzes(in fileURL: URL, quizzes: [Quiz]) -> [String] {
        let fileManager = FileManager.default
        if let existingData = fileManager.contents(atPath: fileURL.path),
            let existingLines = String(data: existingData, encoding: .utf8) {
            let modifiedLines = existingLines.split(separator: "\n").filter { line in
                // Check if the line contains the quizId of the modified quiz
                if let quizIdRange = line.range(of: "\"quizId\":") {
                    let startIndex = line.index(quizIdRange.upperBound, offsetBy: 1)
                    let endIndex = line.endIndex
                    let quizIdSubstring = line[startIndex..<endIndex]
                    return quizzes.contains { $0.quizId == Int(quizIdSubstring) }
                }
                return true
            }
            return modifiedLines.map { String($0) }
        }
        return []
    }

    func writeToFile(fileURL: URL, lines: [Codable]) {
        let encoder = JSONEncoder()
        let encodedLines = lines.compactMap { try? encoder.encode($0) }
        
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            fileHandle.seekToEndOfFile() // Move to the end of the file
            for line in encodedLines {
                fileHandle.write(line)
                fileHandle.write("\n".data(using: .utf8)!)
            }
            fileHandle.closeFile()
        } else {
            print("Failed to create file handle for writing.")
        }
    }


    // Function to load the Quiz objects from the text file
    func loadFromFile() -> [Quiz] {
        var quizzes: [Quiz] = []
        
        if let projectRootURL = getProjectRootDirectory() {
            let textFileFolderURL = projectRootURL.appendingPathComponent("Quizzes/Data")
            let fileURL = textFileFolderURL.appendingPathComponent("quiz.txt")
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let lines = String(data: data, encoding: .utf8)?.split(separator: "\n")
                    
                    let decoder = JSONDecoder()
                    for line in lines ?? [] {
                        if let lineData = line.data(using: .utf8),
                           let quiz = try? decoder.decode(Quiz.self, from: lineData) {
                            quizzes.append(quiz)
                        }
                    }
                    
                    print("Loaded \(quizzes.count) quizzes from file: \(fileURL.path)")
                } catch {
                    print("Error loading quizzes from file: \(error)")
                }
            } else {
                print("Quiz file does not exist at path: \(fileURL.path)")
            }
        }
        
        return quizzes
    }
    
    func loadQuizzes(forUserId userId: Int) -> [Quiz] {
        var quizzes: [Quiz] = []
        
        if let projectRootURL = getProjectRootDirectory() {
            let textFileFolderURL = projectRootURL.appendingPathComponent("Quizzes/Data")
            let fileURL = textFileFolderURL.appendingPathComponent("quiz.txt")
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let lines = String(data: data, encoding: .utf8)?.split(separator: "\n")
                    
                    let decoder = JSONDecoder()
                    for line in lines ?? [] {
                        if let lineData = line.data(using: .utf8),
                           let quiz = try? decoder.decode(Quiz.self, from: lineData),
                           quiz.userId == userId { // Check if the quiz is associated with the desired user ID
                            quizzes.append(quiz)
                        }
                    }
                    
                    print("Loaded \(quizzes.count) quizzes from file: \(fileURL.path)")
                } catch {
                    print("Error loading quizzes from file: \(error)")
                }
            } else {
                print("Quiz file does not exist at path: \(fileURL.path)")
            }
        }
        
        return quizzes
    }
    
    func modifyQuiz(_ quiz: Quiz) {
            var quizzes = loadFromFile()
            
            if let index = quizzes.firstIndex(where: { $0.quizId == quiz.quizId }) {
                quizzes[index] = quiz
                saveToFile(quizzes)
                print("Quiz modified successfully.")
            } else {
                print("Quiz not found.")
            }
        }
    
    func deleteQuiz(_ quiz: Quiz) {
            var quizzes = loadFromFile()

            if let index = quizzes.firstIndex(where: { $0.quizId == quiz.quizId }) {
                quizzes.remove(at: index)
                saveToFile(quizzes)
                print("Quiz deleted successfully.")
            } else {
                print("Quiz not found.")
            }
        }
**/
}

