import Foundation
import SQLite

struct QuizData {
    
    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Function to retrieve user details by ID
    func getUserDetailsById(userId: Int) -> (id: Int, username: String, email: String, password: String)? {
        do {
            let db = try Connection(databaseURL)

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
}
