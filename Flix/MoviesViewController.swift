//
//  MoviesViewController.swift
//  Flix
//
//  Created by Yaying Liang on 2/22/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    // step 1: add tableView
    @IBOutlet weak var tableView: UITableView!
    // step 2: create an array of dictionaries
    var movies = [[String: Any]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // step 3: memorize it for now
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        print("Loading movie data...!")
        
        // movie API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                 
                print(error.localizedDescription)
             } else if let data = data {
                 
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 // Get the results part from dataDictionary
                 // and cast it into an array of dictionaries
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 // reload the data to call the functions again so to return movie count, title
                 self.tableView.reloadData()
                    
                  print(dataDictionary)
                    
                 

                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

             }
        }
        task.resume()
    }
                                                               
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
                                                               
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                     
        // dequeueReusableCell can give a recycle cell
        let cell =
                tableView.dequeueReusableCell(withIdentifier: "MovieCell")
                as! MovieCell
        let movie = movies[indexPath.row] // access each movie in the rows
        let title = movie["title"] as! String // access the title of the movie                                         and cast the title to String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Alamo will use the posterUrl to download the image
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }

}

