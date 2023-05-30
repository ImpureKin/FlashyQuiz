//
//  User.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 22/5/2023.
//

import Foundation

class User {
    var userId: Int?
    var username: String
    var email: String
    let userManager = UserManager()
    
    init(userId: Int, username: String, email: String) {
        self.userId = userId
        self.username = username
        self.email = email
    }
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    //--------Getter Section-------//
    func getUserId() -> Int {
        return userId ?? -1
    }

    func getUsername() -> String {
        return username
    }

    func getEmail() -> String {
        return email
    }

    //-----------------------------//
    
    //--------Setter Section-------//

    func setUsername(newUsername: String) {
        self.username = newUsername
        userManager.updateUsername(userId: userId!, newUsername: newUsername)
    }

    func setEmail(newEmail: String) {
        self.email = newEmail
        userManager.updateEmail(userId: userId!, newEmail: newEmail)
    }

    func setPassword(newPassword: String){
        userManager.updatePassword(userId: userId!, newPassword: newPassword)
    }
    //-----------------------------//
    
    
}
