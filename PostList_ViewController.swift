//
//  ViewController.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit
import SDWebImage

final class PostList_ViewController: UIViewController, RedditPost_Shaerable {
    
    private let CELL_ID = "reddit cell"
    
    private let GO_TO_SPECIFIC_POST = "specific reddit post"
    private let GO_TO_SAVED_POSTS   = "saved posts"
    
    private var isFetchingOrRemovingData = false
    
    private var lastSeletedPost: RedditPost?
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var subRedditName: UILabel!
    
    @IBOutlet private weak var filterSavedPostsButton: UIButton!
    
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.subRedditName.text = "/r/iOS"
        
        // Setting tableView to be resizable based on content
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        
        // Self is responsible for data and behavior (Fat View Controller)
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
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
            
            print("Number of loaded posts: \(String(describing: SavedRedditPosts.loaded.count))")
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
    
    // TODO: Place it somewhere else
    private var postForSharing: RedditPost?
    
    func sharePost(_ post: RedditPost) {
        self.postForSharing = post
        openAcivityVC()
    }
    
    // TODO: see if i actually need this function, maybe i can just do it in teh postForShare
    @objc func openAcivityVC() {
        guard let post = self.postForSharing else {
            assert(false, "Trying to share a nil valued post")
        }
        
        // TODO: Insted of the title share url
        let items = [post.title]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    // TODO: get a better name for the function
    @IBAction func filterSavedPosts(_ sender: Any) {
        self.performSegue(withIdentifier: self.GO_TO_SAVED_POSTS, sender: nil)
        
//        DispatchQueue.main.async {
//            [weak self] in
//            self?.filterSavedPostsButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//            self?.tableView.reloadData()
//
//        }
        
        //        else if self.tableMode == .savedPosts {
        //            DispatchQueue.main.async {
        //                [weak self] in
        //
        //
        //
        //                self?.filterSavedPostsButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        //                self?.tableMode = .normal
        //                SavedRedditPosts.saved.removeAll(where: { $0.isSaved == false })
        //
        //                self?.tableView.reloadData()
        //
        //                // Remove all posts from saved that were unsaved during the saved filter phase
        //
        //
        //                assert(SavedRedditPosts.saved.allSatisfy({ $0.isSaved }), "Post is unsaved in the list of saved posts")
        //            }
        //        }
        
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
        let redditPost = SavedRedditPosts.loaded[indexPath.row]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost, vc: self, state: .insdeTheDefaultPostsList)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        // When to load more posts
        if indexPath.row == SavedRedditPosts.loaded.count - 1 - 5 {
            Task {
                // Getting and loading new data on main thread
                await getNewData(n: 5)
            }
        }
        
        // When to remove new posts on main thread
        let overhead = SavedRedditPosts.loaded.count - 1 - indexPath.row
        if overhead > 15 {
            removeNewData(n: 5)
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
                nextVC.configureSync(redditPost: lastSeletedPost, vc: self, state: .insdeTheDefaultPostsList)
            }
        case self.GO_TO_SAVED_POSTS:
            let nextVC = segue.destination as! SavedPosts_ViewController
            
            // TODO: see if i dont need to set enything up
//            DispatchQueue.main.async {
//                nextVC.configureSync(redditPost: lastSeletedPost, vc: self)
//            }
        default:
            assert(false, "Unknown segue request")
        }
    }
    
}


extension PostList_ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.lastSeletedPost = SavedRedditPosts.loaded[indexPath.row]
        self.performSegue(withIdentifier: self.GO_TO_SPECIFIC_POST, sender: nil)
        
        
    }
}





















