//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/29/22.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var authorBoxStackView: UIStackView!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    var movieQuoteDocumentID: String!
    var movieQuoteListenerRegistration: ListenerRegistration?
    var userListenerRegistration: ListenerRegistration?
    
//    var movieQuote: MovieQuote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("TODO: Listen for document")
//        updateView()
        
    }
    
    func showOrHideEditButton(){
        if(AuthManager.shared.currentUser?.uid == MovieQuoteDocumentManage.shared.latestMovieQuote?.authorUid){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                                                                     target: self,
                                                                     action: #selector(showEditQuoteDialog))
        }else{
            print("This is not your quote, don't allow edit")
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieQuoteListenerRegistration = MovieQuoteDocumentManage.shared.startListening(for: movieQuoteDocumentID!){
            self.updateView()
            self.showOrHideEditButton()
            
            //Start listeining for the user
            self.authorBoxStackView.isHidden = true
            if let authorUid = MovieQuoteDocumentManage.shared.latestMovieQuote?.authorUid{
                UserDocumentManager.shared.stopListening(self.userListenerRegistration)
                self.userListenerRegistration = UserDocumentManager.shared.startListening(for: authorUid){
                    self.updateAuthorBox()
                }
            }
            
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuoteDocumentManage.shared.stopListening(movieQuoteListenerRegistration)
    }
    
    
    func updateView(){
        if let mq = MovieQuoteDocumentManage.shared.latestMovieQuote {
            quoteLabel.text = mq.quote
            movieLabel.text = mq.movie
        }
    }
    
    func updateAuthorBox(){
//        print("TODO: Update the authorBox with name \(UserDocumentManager.shared.name)")
//        print("TODO: Update the authorBox with photoURL \(UserDocumentManager.shared.photoURL)")
        
        self.authorBoxStackView.isHidden = UserDocumentManager.shared.name.isEmpty && UserDocumentManager.shared.photoURL.isEmpty
        authorNameLabel.text = UserDocumentManager.shared.name
        if !UserDocumentManager.shared.photoURL.isEmpty {
            ImageUtils.load(imageView: authorProfileImageView, from: UserDocumentManager.shared.photoURL)
        }
    }
    
    @objc func showEditQuoteDialog(){
        
        
        let alertController = UIAlertController(title: "Edit movie quote",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"//the grey word
//            textField.text = self.movieQuote.quote
            //TODO: Put in the quote from the manager's data
            textField.text = MovieQuoteDocumentManage.shared.latestMovieQuote?.quote
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"//the grey word
//            textField.text = self.movieQuote.movie
            //TODO: Put in the quote from the manager's data
            textField.text = MovieQuoteDocumentManage.shared.latestMovieQuote?.movie
        }
        
        //create an action and add it to the controller
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("You pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        //positive button
        let editQuoteAction = UIAlertAction(title: "Edit quote", style: UIAlertAction.Style.default) { action in
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
//            self.movieQuote.quote = quoteTextField.text!
//            self.movieQuote.movie = movieTextField.text!
//            self.updateView()
            
            //TODO: implement update
            MovieQuoteDocumentManage.shared.update(quote: quoteTextField.text!, movie: movieTextField.text!)
            
        }
        alertController.addAction(editQuoteAction)
        
        present(alertController, animated: true)//to show the thing
    }

}
