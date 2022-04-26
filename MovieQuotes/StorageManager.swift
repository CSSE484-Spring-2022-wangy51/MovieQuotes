//
//  StorageManager.swift
//  MovieQuotes
//
//  Created by Helen Wang on 4/26/22.
//

import Foundation
import Firebase
import UIKit

class StorageManage{
    
   
    static let shared = StorageManage()
    var _storageRef: StorageReference

    private init(){
        _storageRef = Storage.storage().reference()
    }

    func uploadProfilePhoto(uid: String, image: UIImage) {
        guard let imageData = ImageUtils.resize(image: image) else {
            print("Converting the image to data failed!")
            return
        }
        
        let photoRef = _storageRef.child(kUserCollectionPath).child(uid)
        photoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error{
                print("There was an error uploading the image \(error)")
                return
            }
            print("updated complete")
            
            photoRef.downloadURL { downloadURL, error in
                if let error = error{
                    print("There was an error getting the download URL \(error)")
                    return
                }
                print("Get the download URL \(downloadURL?.absoluteString)")
                UserDocumentManager.shared.updatePhotoURL(photoURL: downloadURL?.absoluteString ?? "")
                
                
            }
            
        }
    }
    
    
}
