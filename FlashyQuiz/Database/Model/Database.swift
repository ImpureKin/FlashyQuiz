import Foundation
import SQLite

struct Database {

    func getDatabasePath() -> String {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            fatalError("Failed to retrieve documents directory.")
//        }

//        let databaseURL = documentsDirectory.appendingPathComponent("FlashyQuiz.db")
//        return databaseURL.path
        return "/Users/14300661/Desktop/FlashyQuiz/FlashyQuiz/Database/Model/FlashyQuiz.db"
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
}
