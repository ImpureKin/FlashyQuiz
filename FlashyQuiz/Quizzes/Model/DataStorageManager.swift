//
//  DataStorageManager.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 21/5/2023.
//

import Foundation

class DataStorageManager {
    // Function to get the project's root directory
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
                
                let encoder = JSONEncoder()
                let lines = quizzes.compactMap { try? encoder.encode($0) }
                if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
                    fileHandle.seekToEndOfFile()
                    for line in lines {
                        fileHandle.write(line)
                        fileHandle.write("\n".data(using: .utf8)!)
                    }
                    fileHandle.closeFile()
                } else {
                    fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
                    if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
                        for line in lines {
                            fileHandle.write(line)
                            fileHandle.write("\n".data(using: .utf8)!)
                        }
                        fileHandle.closeFile()
                    } else {
                        print("Failed to create file handle for writing.")
                    }
                }
                
                print("Quizzes saved to file: \(fileURL.path)")
            } catch {
                print("Error saving quizzes to file: \(error)")
            }
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

}

