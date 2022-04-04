//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/28/22.
//

import UIKit

class MovieQuoteTableViewCell: UITableViewCell{
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var movieLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
    
    let kMovieQuoteCell = "MovieQuoteCell"// k for constant
    let kMovieQuoteDetailSegue = "myMovieQuoteDetailSegue"
//    let names = ["Helen", "Lisa", "Peter","Dave"]
//    var movieQuotes = [MovieQuote]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                                 target: self,
                                                                 action: #selector(showAddQuoteDialog))
        
        //Hard code some movie quotes
//        let mq1 = MovieQuote(quote: "I'll be back", movie: "The Terminator")
//        let mq2 = MovieQuote(quote: "Yo Adrian", movie: "Rocky")
//        movieQuotes.append(mq1)
//        movieQuotes.append(mq2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieQuotesCollectionManager.shared.startListening{
//            print("The movie quote were updated")
//            for mq in MovieQuotesCollectionManager.shared.latestMovieQuotes {
//                print("\(mq.quote) on \(mq.movie)")
//            }
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuotesCollectionManager.shared.stopListening()
    }
    
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
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.insert(mq, at: 0)
//            self.tableView.reloadData()
            //TODO: figure out if this works
            MovieQuotesCollectionManager.shared.add(mq)
            
        }
        alertController.addAction(createQuoteAction)
        
        present(alertController, animated: true)//to show the thing
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
//        return movieQuotes.count
        return MovieQuotesCollectionManager.shared.latestMovieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell

//         Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.row)"//indexPath has only .row and .session
//        cell.textLabel?.text =[indexPath.row]
//        cell.textLabel?.text = movieQuotes[indexPath.row].quote
//        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
//        cell.quoteLabel.text = movieQuotes[indexPath.row].quote
//        cell.movieLabel.text = movieQuotes[indexPath.row].movie
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        cell.quoteLabel.text = mq.quote
        cell.movieLabel.text = mq.movie

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: implement delete
//            movieQuotes.remove(at: indexPath.row)
//            tableView.reloadData()
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
//                mqdvc.movieQuote = movieQuotes[indexPath.row]
                //TODO: inform the detail view about eh MovieQuote
                //Note: For now this will CRASH!!!
            }
        }
    }
    

}
