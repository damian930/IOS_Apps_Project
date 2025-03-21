//
//  ViewController.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    private var redditPosts = [RedditPost]()
    
    private let CELL_ID = "reddit cell"
    
    private let GO_TO_SPECIFIC_POST = "specific reddit post"
    
    private var isFetchingOrRemovingData = false
    
    private var lastSeletedPost: RedditPost?
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting tableView to be resizable based on content
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        
        // Self is responsible for data and behavior (Fat View Controller)
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
        // Feting the original data
        Task {
            self.redditPosts = await getRedditPosts(limit: 10)
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
        
    }
    
    // Loading new data and store at the end
    private func getNewData() async {
        if self.isFetchingOrRemovingData { return }
        self.isFetchingOrRemovingData = true
        
        let lastPost = self.redditPosts[self.redditPosts.count - 1]
        let newData  = await getRedditPosts(limit: 10, after: lastPost.id)
        self.redditPosts.append(contentsOf: newData)
        
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.isFetchingOrRemovingData = false
            
            print("Number of loaded posts: \(String(describing: self?.redditPosts.count))")
        }
    }
    
    func removeNewData() {
        if self.isFetchingOrRemovingData { return }
        self.isFetchingOrRemovingData = true
        
        self.redditPosts.removeLast(5)
            
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.isFetchingOrRemovingData = false
            
            print("Number of loaded posts: \(String(describing: self?.redditPosts.count))")
        }
        
    }

    
}

extension ViewController: UITableViewDataSource {
    // How many rows will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.redditPosts.count
    }
    
    // Cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RedditPost_TableCell
        
        let redditPost = self.redditPosts[indexPath.row]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // When to load more posts
        if indexPath.row == self.redditPosts.count - 3 {
            Task {
                // Getting and loading new data on main thread
                await getNewData()
            }
        }
        
        // When to remove new posts on main thread
        if indexPath.row >= 10 && self.redditPosts.count > indexPath.row + 10 {
            removeNewData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case self.GO_TO_SPECIFIC_POST:
            let nextVC = segue.destination as! SelectedRedditPost_ViewController
            guard let lastSeletedPost = self.lastSeletedPost else {
                assert(false)
            }
            DispatchQueue.main.async {
                nextVC.configureSync(redditPost: lastSeletedPost)
            }
        default: break
        }
    }
    
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.lastSeletedPost = self.redditPosts[indexPath.row]
        self.performSegue(withIdentifier: self.GO_TO_SPECIFIC_POST, sender: nil)
    }
}















// @ TODO: add the button back into the reddit view

//    @IBAction func savedButtonPressed(_ sender: UIButton) {
//        // Unwrapping optional post and saving state for logging
//        guard var post = currentPost else { return }
//        let prevState  = post.saved
//
//        // Updating the button image
//        post.saved.toggle()
//        self.currentPost = post
//        updateBookmarkButton(isSaved: post.saved)
//
////        print("Bookmark cahnged from \(prevState) to \(self.currentPost?.saved as Any)")
//    }
//
//    private func updateBookmarkButton(isSaved: Bool) {
//        // Changing the button image
//        if isSaved {
//            self.redditPostSaveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//        } else {
//            self.redditPostSaveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
//        }
//    }






