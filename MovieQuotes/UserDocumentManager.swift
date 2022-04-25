//
//  UserDocumentManager.swift
//  Users
//
//  Created by Helen Wang on 4/25/22.
//

import Foundation
import Firebase
//import UIKit

class UserDocumentManager{
    
    var _latestDocument: DocumentSnapshot?

    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference

    private init(){
        _collectionRef = Firestore.firestore().collection(kUserCollectionPath)
    }
    
    //TODO: Implement Create
    
    func startListening(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration{//it is documentID and Uid
        
        let query = _collectionRef.document(documentID)// order the collection
        
        return query.addSnapshotListener { documentSnapshot, error in
            self._latestDocument = nil
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard document.data() != nil else {
                print("Document data was empty.")
                return
              }

            self._latestDocument = document
            changeListener()
            }
        
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        listenerRegistration?.remove();
    }
    
    var name: String{
        if let name = _latestDocument?.get(kUserName) {
            return name as! String
        }
        return ""
    }
    
    var photoURL: String{
        if let photoURL = _latestDocument?.get(kUserPhotoURL) {
            return photoURL as! String
        }
        return ""
    }
    
    func updateName(name: String){
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserName: name,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Name successfully updated")
            }
        }
    }
    
    func updatePhotoURL(photoURL: String){
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserPhotoURL: photoURL,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("PhotoURL successfully updated")
            }
        }
    }
    
}
