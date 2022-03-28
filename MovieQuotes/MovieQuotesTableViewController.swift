//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Helen Wang on 3/28/22.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
    
    let kMovieQuoteCell = "MovieQuoteCell"// k for constant
    let names = ["Helen", "Lisa", "Peter","Dave"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kMovieQuoteCell, for: indexPath)

//         Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.row)"//indexPath has only .row and .session
        cell.textLabel?.text = names[indexPath.row]

        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: implement delete
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
