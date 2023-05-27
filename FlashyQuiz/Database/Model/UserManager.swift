import Foundation
import SQLite

struct UserManager {
    
    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Add user to Database - Register user
    func addUser(username: String, email: String, password: String) -> String {
        var result = ""
        do {
            let db = try Connection(databaseURL)
            let usersTable = Table("Users")
            let usernameCol = Expression<String>("username")
            let emailCol = Expression<String>("email")
            let passwordCol = Expression<String>("password")

            try db.run(usersTable.insert(usernameCol <- username, emailCol <- email.lowercased(), passwordCol <- password))
            
            result = "Success - User '\(username)' has been added to database."
            print(result) // To remove
            return result
        } catch {
            result = "Error - Unable to insert user to database: \(error)"
            print(result) // To remove
            return result
        }
        
    }
    
    // Retrieve user from Database based on ID - return their details -- REMOVE?
    func getUserDetails(userId: Int) -> (id: Int, username: String, email: String)? {
        do {
            let db = try Connection(databaseURL)
            let usersTable = Table("Users")
            let idCol = Expression<Int>("id")
            let usernameCol = Expression<String>("username")
            let emailCol = Expression<String>("email")
            
            guard let user = try db.pluck(usersTable.filter(idCol == userId)) else { // Find user in database with matching userID
                return nil // User with the specified ID not found
            }

            let userDetails = (
                id: user[idCol],
                username: user[usernameCol],
                email: user[emailCol]
            )
            print("Success - User '\(userDetails.username)' has been retrieved from database.")
            return userDetails
        } catch {
            print("Error - Unable to retrieve user details: \(error)")
            return nil
        }
    }
    
    // Login the user based on combination of email and password provided
    func loginUser(email: String, password: String) -> User? {
        do {
            let db = try Connection(databaseURL)
            let usersTable = Table("Users")
            let idCol = Expression<Int>("id")
            let usernameCol = Expression<String>("username")
            let emailCol = Expression<String>("email")
            let passwordCol = Expression<String>("password")
            guard let user = try db.pluck(usersTable.filter(emailCol == email.lowercased())) else { // Find user within database with email provided
                return nil // User with the specified email not found
            }
            
            if user[passwordCol] == password { // User with specified email found. Check if provided password is correct
                let loggedUser = User(userId: user[idCol], username: user[usernameCol], email: user[emailCol]) // create loggedUser with DB details
                return loggedUser // User with specified email AND password is found
            } else {
                return nil // User with sepcified email exists but provided password does not match database entry
            }
        } catch {
            print("Error - Could not authenticate user login details: \(error)")
            return nil
        }
    }
}