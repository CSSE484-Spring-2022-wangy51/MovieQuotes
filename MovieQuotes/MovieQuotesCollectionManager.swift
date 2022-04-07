//
//  MovieQuotesCollectionManager.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/31/22.
//

import Foundation
import Firebase

class MovieQuotesCollectionManager{
    
    // swift singleten
    static let shared = MovieQuotesCollectionManager()
    var _collectionRef: CollectionReference
//    var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    var latestMovieQuotes = [MovieQuote]()
    
    func startListening(changeListener: @escaping (() -> Void)) -> ListenerRegistration{// recieves a function that takes no parameter and return void
        //DONE: receive change listener
        
        let query = _collectionRef.order(by: kMovieQuoteLastTouched, descending: true).limit(to: 50)// order the collection
        
        return query.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {// if exist then carry on, else stop and print
                    print("Error fetching documents: \(error!)")
                    return
                }
            self.latestMovieQuotes.removeAll()
                for document in documents {
                    print("\(document.documentID) => \(document.data())")
                    self.latestMovieQuotes.append(MovieQuote(doucmentSnapshot: document))
                }
                changeListener()
            }
        
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        print("Removing the listener")
        listenerRegistration?.remove();
        
    }
    
    func add(_ mq: MovieQuote){
        _collectionRef.addDocument(data: [
            kMovieQuoteQuote : mq.quote,
            kMovieQuoteMovie: mq.movie,
            kMovieQuoteLastTouched: Timestamp.init(),
            kMovieQuoteAuthorUid: AuthManager.shared.currentUser!.uid
        ]){err in
            if let err = err {
                print("Error adding document \(err)")
            }
        }
    }
    func delete(_ documentId: String){
        _collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
}

