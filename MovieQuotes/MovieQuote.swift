//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/28/22.
//

import Foundation
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var documentID: String?
    var authorUid: String?
    
    init(quote: String, movie: String){
        self.quote = quote
        self.movie = movie
    }
    
    init(doucmentSnapshot: DocumentSnapshot){
        self.documentID = doucmentSnapshot.documentID
        let data = doucmentSnapshot.data()
        self.quote = data?[kMovieQuoteQuote] as? String ?? ""
        self.movie = data?[kMovieQuoteMovie] as? String ?? ""// if data exist then give me the quote if it does not exist give me this empty string instead
        self.authorUid = data?[kMovieQuoteAuthorUid] as? String ?? ""
    }
}
