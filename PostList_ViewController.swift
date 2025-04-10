//
//  ViewController.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit
import SDWebImage

final class PostList_ViewController: UIViewController {
    
    private let CELL_ID = "reddit cell"
    
    private let GO_TO_SPECIFIC_POST = "specific reddit post"
    private let GO_TO_SAVED_POSTS   = "saved posts"
    
    private var isFetchingOrRemovingData = false
    
    private var lastSelectedPost: RedditPost?
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var subRedditName: UILabel!
    
    @IBOutlet private weak var filterSavedPostsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let offset = self.tableView.contentOffset
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(offset, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
            
            self?.subRedditName.text = "/r/iOS"
            
            // Setting tableView to be resizable based on content
            self?.tableView.rowHeight          = UITableView.automaticDimension
            self?.tableView.estimatedRowHeight = 400
            
            // Self is responsible for data and behavior (Fat View Controller)
            self?.tableView.dataSource = self
            self?.tableView.delegate   = self
        }
        
        // Feting the original data
        Task {
            SavedRedditPosts.loaded = await getRedditPosts(limit: 10)
            
            for (index, post) in SavedRedditPosts.loaded.enumerated() {
                if SavedRedditPosts.saved.contains(where: { $0.id == post.id }) {
                    SavedRedditPosts.loaded[index].isSaved = true
                }
            }
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
        
    }
    
    // Loading new data and store at the end
    private func getNewData(n: Int) async {
        if self.isFetchingOrRemovingData { return }
        self.isFetchingOrRemovingData = true
        
        let lastPost = SavedRedditPosts.loaded[SavedRedditPosts.loaded.count - 1]
        let newData  = await getRedditPosts(limit: n, after: lastPost.id)
        SavedRedditPosts.loaded.append(contentsOf: newData)
        
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.isFetchingOrRemovingData = false
            
        
        }
    }
    
    func removeNewData(n: Int) {
        if self.isFetchingOrRemovingData { return }
        self.isFetchingOrRemovingData = true
        
        SavedRedditPosts.loaded.removeLast(n)
        
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
            self?.isFetchingOrRemovingData = false
            
            print("Number of loaded posts: \(String(describing: SavedRedditPosts.loaded.count))")
        }
        
    }
    
//    TODO: remove this
    @IBAction func openSavedPosts(_ sender: Any) {
        self.performSegue(withIdentifier: self.GO_TO_SAVED_POSTS, sender: nil)
    }
    
    
    
}

extension PostList_ViewController: UITableViewDataSource {
    // How many rows will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedRedditPosts.loaded.count
    }
    
    // Cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RedditPost_TableCell
        
        print("Created cell")
//        print("\n\n")
//        print("Post title: \(SavedRedditPosts.loaded[indexPath.row].title)")
//        print("Before:     \(String(describing: cell.vc))")
        cell.configure(vc: self)
//        print("After:      \(String(describing: cell.vc))")
//        print("\n\n")
        
//        cell.configure(vc: self)
        let redditPost = SavedRedditPosts.loaded[indexPath.row]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost, vc: self, state: .insdeTheDefaultPostsList)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case self.GO_TO_SPECIFIC_POST:
            print(3)
            let nextVC = segue.destination as! SelectedRedditPost_ViewController
            guard let lastSeletedPost = self.lastSelectedPost else {
                assert(false, "last selected is not set, illegal")
            }
            print(4)
            DispatchQueue.main.async {
                nextVC.configureSync(redditPost: lastSeletedPost, vc: self, state: .insdeTheDefaultPostsList)
            }
        case self.GO_TO_SAVED_POSTS:
            let _ = segue.destination as! SavedPosts_ViewController
            // Just doing casting to see if the view is correct
        default:
            assert(false, "Unknown segue request")
        }
    }
    
}


extension PostList_ViewController: UITableViewDelegate {
    
    // Behaviour when loading
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // When to load more posts
        if indexPath.row == SavedRedditPosts.loaded.count - 1 - 5 {
            Task {
                // Getting and loading new data on main thread
                await getNewData(n: 5)
                
                print("New data loaded, new count: \(SavedRedditPosts.loaded.count)")
            }
        }
        
        // When to remove new posts on main thread
        let overhead = SavedRedditPosts.loaded.count - 1 - indexPath.row
        if overhead > 15 {
            removeNewData(n: 5)
            
            print("Removed data loaded, new count: \(SavedRedditPosts.loaded.count)")
        }
        
    }
    
}


extension PostList_ViewController: RedditPost_Shaerable {
    
    func sharePost(_ post: RedditPost) {
        let items = ["https://www.reddit.com/r/\(post.domain)/comments/\(post.id)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        DispatchQueue.main.async {
            [weak self] in
            self?.present(ac, animated: true)
        }
    }
    
}

extension PostList_ViewController: RedditPost_SingleTappable {
    
    func singleTapHandler(post: RedditPost) {
        self.lastSelectedPost = post
        print(2)
        self.performSegue(withIdentifier: self.GO_TO_SPECIFIC_POST, sender: nil)
        
    }
    
}



















