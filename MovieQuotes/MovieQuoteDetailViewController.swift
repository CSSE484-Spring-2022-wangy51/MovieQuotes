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

}
