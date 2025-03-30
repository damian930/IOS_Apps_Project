//
//  SavedPosts_ViewController.swift
//  hm_2
//
//  Created by  Damian  on 29.03.2025.
//

import UIKit

class SavedPosts_ViewController: UIViewController {
    
    private let CELL_ID = "reddit cell"
    
    private let GO_TO_SPECIFIC_POST = "specific reddit post"
    
    private var lastSeletedPost: RedditPost?
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var filteredPosts: [RedditPost] = []
    
    private var isSearching: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let offset = self.tableView.contentOffset
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(offset, animated: false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Setting tableView to be resizable based on content
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        
        // Self is responsible for data and behavior (Fat View Controller)
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
        self.searchBar.delegate   = self
    }
    
}

extension SavedPosts_ViewController: UITableViewDataSource {
    // How many rows will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? self.filteredPosts.count : SavedRedditPosts.saved.count
    }
    
    // Cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RedditPost_TableCell
        let redditPost = isSearching ? self.filteredPosts[indexPath.row] : SavedRedditPosts.saved[indexPath.row]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost, vc: self, state: .insideTheListOfSaved)
        
//        print("\nDebug")
//        print("\(redditPost.title)")
//        print("\(redditPost.images.first)\n")
        
        return cell
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case self.GO_TO_SPECIFIC_POST:
            let nextVC = segue.destination as! SelectedRedditPost_ViewController
            guard let lastSeletedPost = self.lastSeletedPost else {
                assert(false)
            }
            DispatchQueue.main.async {
                nextVC.configureSync(redditPost: lastSeletedPost, vc: self, state: .insideTheListOfSaved)
            }
        default:
            assert(false, "Unknown segue request")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Since we are in the saved posts table, i dont want the table to refresh everytime a post get unsaved. Also if user does it accidentally they cant save it back, cause its gone. This way i kinda unssafely make posts unsaved inside the list of saved (whitch is kinda prohibited but makes sence here). The main thing is then to remove them from saved once we move back into notmal list of posts. If that is not done properly, asserts will catch it. Everywhere where SaveRedditPost.save / .unsave is used asserts are present
        
        if isMovingFromParent {
            // UNSAFE REMVING OF THE NEWLY uNSAVED POSTS
            SavedRedditPosts.saved.removeAll(where: { $0.isSaved == false })
        }
        
    }
    
}


extension SavedPosts_ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSeletedPost = isSearching ? filteredPosts[indexPath.row] : SavedRedditPosts.saved[indexPath.row]
        self.performSegue(withIdentifier: self.GO_TO_SPECIFIC_POST, sender: nil)
        
    }
}

extension SavedPosts_ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredPosts = SavedRedditPosts.saved.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.searchBar.text = ""
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
}

extension SavedPosts_ViewController: RedditPost_Shaerable {
    
    func sharePost(_ post: RedditPost) {
        let items = ["https://www.reddit.com/r/\(post.domain)/comments/\(post.id)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        DispatchQueue.main.async {
            [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
}
