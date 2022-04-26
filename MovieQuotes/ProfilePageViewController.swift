//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 4/21/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var userListenerRegistration: ListenerRegistration?

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListenerRegistration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid){
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
    }
    
    
    @IBAction func displayNameDidChange(_ sender: Any) {
//        print("TODO: Update name to \(displayNameTextField.text)")
        UserDocumentManager.shared.updateName(name: displayNameTextField!.text!)
    }
    
    @IBAction func pressedChangePhoto(_ sender: Any) {
        print("TODO: change photo")
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    func updateView(){
        displayNameTextField.text = UserDocumentManager.shared.name
        if !UserDocumentManager.shared.photoURL.isEmpty {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserDocumentManager.shared.photoURL)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            profilePhotoImageView.image = image // Quick test
            StorageManage.shared.uploadProfilePhoto(uid: AuthManager.shared.currentUser!.uid, image: image)
        }
        picker.dismiss(animated: true)
    }
}
