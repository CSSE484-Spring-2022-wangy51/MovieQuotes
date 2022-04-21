//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/28/22.
//

import UIKit
import Firebase
import AudioToolbox

class MovieQuoteTableViewCell: UITableViewCell{
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var movieLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
    
    let kMovieQuoteCell = "MovieQuoteCell"// k for constant
    let kMovieQuoteDetailSegue = "myMovieQuoteDetailSegue"
    var movieQuotesListenerRegistration: ListenerRegistration?
    
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                                 target: self,
                                                                 action: #selector(showAddQuoteDialog))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰",
//                                                                 style: UIBarButtonItem.Style.plain,
//                                                                 target: self,
//                                                                 action: #selector(showMenue))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForMovieQuotes()
        
        //TODO: Eventually use real login, but for now use Guest Mode / Anonymous login

        logoutHandle = AuthManager.shared.addLogoutObserver {
            print("Someone sign out, go back to LoginViewController")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForMovieQuotes()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    
    func startListeningForMovieQuotes(){
//        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening{
//            self.tableView.reloadData()
//        }
        stopListeningForMovieQuotes()// does nothing the 1st time, stop the last listener
        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening(filterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid)
        {
            self.tableView.reloadData()
        }
    }
    
    
    func stopListeningForMovieQuotes(){
        MovieQuotesCollectionManager.shared.stopListening(movieQuotesListenerRegistration)
    }
    
    
//    @objc func showMenue(){
//       let alertController = UIAlertController(title: nil,
//                                               message: nil,
//                                               preferredStyle: UIAlertController.Style.actionSheet)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
//            print("You pressed cancel")
//        }
//        alertController.addAction(cancelAction)
//
//        //show all quotes/ show only my quote button
//        let showOnlyMyQuotesAction = UIAlertAction(title: isShowingAllQuotes ? "Show only my quotes" : "Show all quotes",
//                                                   style: UIAlertAction.Style.default) { action in
//            print("show only my quotes")
//            self.isShowingAllQuotes = !self.isShowingAllQuotes
//
//            self.startListeningForMovieQuotes()
//        }
//        alertController.addAction(showOnlyMyQuotesAction)
//
//        //show add quote
//        let showAddQuoteAction = UIAlertAction(title: "Add a quotes", style: UIAlertAction.Style.default) { action in
//            self.showAddQuoteDialog()
//        }
//        alertController.addAction(showAddQuoteAction)
//
//        //sign out
//        let signOutAction = UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default) { action in
////            print("sign out")
//            AuthManager.shared.signOUt()
//        }
//        alertController.addAction(signOutAction)
//
//        present(alertController, animated: true)
//    }
    
    
    //the override in objectC
    @objc func showAddQuoteDialog(){
        print("you pressed the add button")
        
        let alertController = UIAlertController(title: "Create a new movie quote",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"//the grey word
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"//the grey word
        }
        
        //create an action and add it to the controller
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("You pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        //positive button
        let createQuoteAction = UIAlertAction(title: "Create quote", style: UIAlertAction.Style.default) { action in
            print("You pressed create quote")
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            print("Quote: \(quoteTextField.text!)")
//            print("Movie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            
            MovieQuotesCollectionManager.shared.add(mq)
            
        }
        alertController.addAction(createQuoteAction)
        
        present(alertController, animated: true)//to show the thing
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return MovieQuotesCollectionManager.shared.latestMovieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell

//         Configure the cell...

        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        cell.quoteLabel.text = mq.quote
        cell.movieLabel.text = mq.movie

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        return AuthManager.shared.currentUser?.uid == mq.authorUid
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let mqToDelete = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
            MovieQuotesCollectionManager.shared.delete(mqToDelete.documentID!)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kMovieQuoteDetailSegue{
            // Get the new view controller using segue.destination.
            let mqdvc = segue.destination as! MovieQuoteDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                
                //DONE: inform the detail view about the MovieQuote
                let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
                mqdvc.movieQuoteDocumentID = mq.documentID
                
                
            }
        }
    }
    

}
