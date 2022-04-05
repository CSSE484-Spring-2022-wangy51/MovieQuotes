//
//  MovieQuoteDocumentManager.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/31/22.
//

import Foundation
import Firebase
import UIKit

class MovieQuoteDocumentManage{
    
    var latestMovieQuote: MovieQuote?
    static let shared = MovieQuoteDocumentManage()
    var _collectionRef: CollectionReference

    private init(){
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    
    func startListening(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration{// recieves a function that takes no parameter and return void
        //DONE: receive change listener
        
        let query = _collectionRef.document(documentID)// order the collection
        
        return query.addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
            guard document.data() != nil else {
                print("Document data was empty.")
                return
              }
//              print("Current data: \(data)")
            self.latestMovieQuote = MovieQuote(doucmentSnapshot: document)
            changeListener()
            }
        
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        print("Removing the listener")
        listenerRegistration?.remove();
        
    }
    
    func update(quote: String, movie: String){
        
        _collectionRef.document(latestMovieQuote!.documentID!).updateData([
            kMovieQuoteQuote: quote,
            kMovieQuoteMovie: movie,
            kMovieQuoteLastTouched: Timestamp.init(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}
