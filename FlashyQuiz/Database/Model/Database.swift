import Foundation
import SQLite

struct Database {
    
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
            print(databaseURL)
            return databaseURL.absoluteString
        } else {
            return "Error: Failed to find database path."
        }
    }
    
    // Function to retrieve user details by ID
    func getUserDetailsById(userId: Int) -> (id: Int, username: String, email: String, password: String)? {
        do {
            let db = try Connection(getDatabasePath())

            let tableUsers = Table("Users")
            let id = Expression<Int>("id")
            let password = Expression<String>("password")
            let username = Expression<String>("username")
            let email = Expression<String>("email")

            guard let user = try db.pluck(tableUsers.filter(id == userId)) else {
                return nil // User with the specified ID not found
            }

            let userDetails = (
                id: user[id],
                username: user[username],
                email: user[email],
                password: user[password]
            )
            return userDetails
        } catch {
            print("Error retrieving user details: \(error)")
            return nil
        }
    }
    
    // Function to retrieve user details by username
    func getUserDetailsById(usernameInput: String) -> (id: Int, username: String, email: String, password: String)? {
        do {
            let db = try Connection(getDatabasePath())

            let tableUsers = Table("Users")
            let id = Expression<Int>("id")
            let password = Expression<String>("password")
            let username = Expression<String>("username")
            let email = Expression<String>("email")

            guard let user = try db.pluck(tableUsers.filter(username == usernameInput)) else {
                return nil // User with the specified username not found
            }

            let userDetails = (
                id: user[id],
                username: user[username],
                email: user[email],
                password: user[password]
            )
            return userDetails
        } catch {
            print("Error retrieving user details: \(error)")
            return nil
        }
    }
    
    // Function to retrieve user details by email
    func getUserDetailsById(emailInput: String) -> (id: Int, username: String, email: String, password: String)? {
        do {
            let db = try Connection(getDatabasePath())

            let tableUsers = Table("Users")
            let id = Expression<Int>("id")
            let password = Expression<String>("password")
            let username = Expression<String>("username")
            let email = Expression<String>("email")

            guard let user = try db.pluck(tableUsers.filter(email == emailInput)) else {
                return nil // User with the specified email not found
            }

            let userDetails = (
                id: user[id],
                username: user[username],
                email: user[email],
                password: user[password]
            )
            return userDetails
        } catch {
            print("Error retrieving user details: \(error)")
            return nil
        }
    }
}
