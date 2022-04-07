//
//  AuthManager.swift
//  MovieQuotes
//
//  Created by Helen Wang on 4/7/22.
//

import Foundation
import Firebase

class AuthManager{
    static let shared = AuthManager()
    private init(){
        
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var isSignedIn: Bool{
        currentUser != nil
    }
    
    func addLoginObserver(callback: @escaping (()->Void)) -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { auth, user in
            if (user == nil){
                callback()
            }
        }
    }
    
    func addLogoutObserver (callback:@escaping (()->Void)) -> AuthStateDidChangeListenerHandle{
////        if authDidChangeHandle != nil{
////            Auth.auth().removeStateDidChangeListener(authDidChangeHandle!)
////        }
//
//        if let authHandle = authDidChangeHandle{
//            Auth.auth().removeStateDidChangeListener(authHandle)
//        }
        return Auth.auth().addStateDidChangeListener { auth, user in
            if (user == nil){
                callback()
            }
        }
    }
    
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?){
        //        if authDidChangeHandle != nil{
        //            Auth.auth().removeStateDidChangeListener(authDidChangeHandle!)
        //        }
                
        if let authHandle = authDidChangeHandle{
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func signInNewEmailPasswordUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("There was an error creating the user: \(error)")
                return
            }
            print("User created")
        }
    }
    
    func loginExistingEmailPasswordUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("There was an error logging in existing user: \(error)")
                return
            }
            print("User login")
        }
    }
    
    func signInAnonymously(){
        Auth.auth().signInAnonymously() { authResult, error in
            if let error = error{
                print("There was an error with anonymous sign in: \(error)")
                return
            }
            print("Anonymous sign in complete")
        }
    }
    
}
