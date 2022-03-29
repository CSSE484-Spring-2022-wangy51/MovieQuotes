//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/29/22.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    var movieQuote: MovieQuote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                                                                 target: self,
                                                                 action: #selector(showEditQuoteDialog))
        updateView()
        
    }
    
        //if viewDidLoad crashes, I could do this
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateView()
//    }
    
    func updateView(){
        quoteLabel.text = movieQuote.quote
        movieLabel.text = movieQuote.movie
    }
    
    @objc func showEditQuoteDialog(){
        
        
        let alertController = UIAlertController(title: "Edit movie quote",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"//the grey word
            textField.text = self.movieQuote.quote
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"//the grey word
            textField.text = self.movieQuote.movie
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
            
            self.movieQuote.quote = quoteTextField.text!
            self.movieQuote.movie = movieTextField.text!
            self.updateView()
            
        }
        alertController.addAction(editQuoteAction)
        
        present(alertController, animated: true)//to show the thing
    }

}