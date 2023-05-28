import Foundation
import SQLite

struct UserManager {
    
    let databaseURL = DatabaseManager().getDatabasePath()
    
    let userTable = Table("Users")
    let userIdCol = Expression<Int>("id")
    let usernameCol = Expression<String>("username")
    let emailCol = Expression<String>("email")
    let passwordCol = Expression<String>("password")
    
    // Add user to Database - Register user
    func addUser(username: String, email: String, password: String) -> String {
        var result = ""
        do {
            let db = try Connection(databaseURL)

            try db.run(userTable.insert(usernameCol <- username, emailCol <- email.lowercased(), passwordCol <- password))
            
            result = "Success - User '\(username)' has been added to database."
            print(result) // To remove
            return result
        } catch {
            result = "Error - Unable to insert user to database: \(error)"
            print(result) // To remove
            return result
        }
        
    }
    
    // Login the user based on combination of email and password provided
    func loginUser(email: String, password: String) -> User? {
        do {
            // DB connection
            let db = try Connection(databaseURL)

            guard let user = try db.pluck(userTable.filter(emailCol == email.lowercased())) else { // Find user within database with email provided
                return nil // User with the specified email not found
            }
            
            if user[passwordCol] == password { // User with specified email found. Check if provided password is correct
                let loggedUser = User(userId: user[userIdCol], username: user[usernameCol], email: user[emailCol]) // create loggedUser with DB details
                return loggedUser // User with specified email AND password is found
            } else {
                return nil // User with sepcified email exists but provided password does not match database entry
            }
        } catch {
            print("Error - Could not authenticate user login details: \(error)")
            return nil
        }
    }
    
    // Change user's username
    func updateUsername(userId: Int, newUsername: String) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            let user = userTable.filter(userIdCol == userId) // SELECT * FROM users WHERE id = userId
            return try db.run(user.update(usernameCol <- newUsername)) > 0 // UPDATE users SET username = newUsername WHERE id = userId
        } catch {
            print("Error - Could not change username: \(error)")
            return false
        }
    }
    
    // Change user's email
    func updateEmail(userId: Int, newEmail: String) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            let user = userTable.filter(userIdCol == userId) // SELECT * FROM users WHERE id = userId
            return try db.run(user.update(emailCol <- newEmail)) > 0 // UPDATE users SET email = newEmail WHERE id = userId
        } catch {
            print("Error - Could not change email: \(error)")
            return false
        }
    }
    
    // Change user's password
    func updatePassword(userId: Int, newPassword: String) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            let user = userTable.filter(userIdCol == userId) // SELECT * FROM users WHERE id = userId
            return try db.run(user.update(passwordCol <- newPassword)) > 0 // UPDATE users SET password = newPassword WHERE id = userId
        } catch {
            print("Error - Could not change password: \(error)")
            return false
        }
    }
}
