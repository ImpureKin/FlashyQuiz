import Foundation
import SQLite

struct DatabaseManager {
    func getProjectRootDirectory() -> URL? {
        let currentFileURL = URL(fileURLWithPath: #file)
        let projectRootURL = currentFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return projectRootURL
    }

    func getDatabasePath() -> String {
        if let projectRootURL = getProjectRootDirectory() {
            let databaseFileFolderURL = projectRootURL.appendingPathComponent("Database/Model")
            let databaseURL = databaseFileFolderURL.appendingPathComponent("FlashyQuiz.db")
            return databaseURL.absoluteString
        } else {
            return "Error: Failed to find database path."
        }
    }
}
