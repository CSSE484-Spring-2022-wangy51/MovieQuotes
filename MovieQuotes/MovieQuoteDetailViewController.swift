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
    
    var movieQuoteDocumentID: String!
    var movieQuoteListenerRegistration: ListenerRegistration?
    
//    var movieQuote: MovieQuote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("TODO: Listen for document")
        updateView()
        
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
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuoteDocumentManage.shared.stopListening(movieQuoteListenerRegistration)
    }
    
        //if viewDidLoad crashes, I could do this
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateView()
//    }
    
    func updateView(){
        //TODO: update the view using the manager
//        quoteLabel.text = movieQuote.quote
//        movieLabel.text = movieQuote.movie
        
        if let mq = MovieQuoteDocumentManage.shared.latestMovieQuote {
            quoteLabel.text = mq.quote
            movieLabel.text = mq.movie
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
