//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 4/18/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.placeholder = "Email"
        passwordTexField.placeholder = "Password"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginObserver {
//            print("TODO:  There is already someone signed in! Skip the LoginViewController")
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }
    
    @IBAction func pressedCreateNewUser(_ sender: Any) {
 
        let email = emailTextField.text!
        let password = passwordTexField.text!
        print("press new user. Email = \(email), Password = \(password)")
        
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
    }
    
    @IBAction func pressedLoginExistingUser(_ sender: Any) {
       
        let email = emailTextField.text!
        let password = passwordTexField.text!
        print("press log in existing user. Email = \(email), Password = \(password)")
        
        AuthManager.shared.loginExistingEmailPasswordUser(email: email, password: password)
        
    }
    
    @IBAction func pressedRosefire(_ sender: Any) {
        print(" Use Rosefire")
        
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: kRosefireRegistryToken) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
//          print("Result = \(result!.token!)")
//          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
//          print("Result = \(result!.email!)")
//          print("Result = \(result!.group!)")
            AuthManager.shared.signInWithRosefireToken(result!.token)

        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
