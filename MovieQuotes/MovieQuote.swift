//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/28/22.
//

import Foundation

class MovieQuote {
    var quote: String
    var movie: String
    var documentID: String?
    
    init(quote: String, movie: String){
        self.quote = quote
        self.movie = movie
    }
}
