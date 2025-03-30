//
//  SavedPosts_ViewController.swift
//  hm_2
//
//  Created by  Damian  on 29.03.2025.
//

import UIKit

class SavedPosts_ViewController: UIViewController, RedditPost_Shaerable {
    
    private let CELL_ID = "reddit cell"
    
    private let GO_TO_SPECIFIC_POST = "specific reddit post"
    
    private var lastSeletedPost: RedditPost?
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var subRedditName: UILabel!
    
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
        
        self.subRedditName.text = "/r/iOS"
        
        // Setting tableView to be resizable based on content
        self.tableView.rowHeight          = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        
        // Self is responsible for data and behavior (Fat View Controller)
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
        // self.tableView.reloadData()
        
    }
    
    // TODO: Place it somewhere else
    private var postForSharing: RedditPost?
    
    func sharePost(_ post: RedditPost) {
        self.postForSharing = post
        openAcivityVC()
    }
    
    @objc func openAcivityVC() {
        guard let post = self.postForSharing else {
            assert(false, "Trying to share a nil valued post")
        }
        
        // TODO: Insted of the title share url
        let items = [post.title]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

extension SavedPosts_ViewController: UITableViewDataSource {
    // How many rows will be in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SavedRedditPosts.saved.count
        
        
        
    }
    
    // Cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RedditPost_TableCell
        let redditPost = SavedRedditPosts.saved[indexPath.row]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost, vc: self, state: .insideTheListOfSaved)
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
        
        if isMovingFromParent {
            // UNSAFE REMVING OF THE NEWLY INSAVED POSTS
            SavedRedditPosts.saved.removeAll(where: { $0.isSaved == false })
        }
    }
    
}


extension SavedPosts_ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.lastSeletedPost = SavedRedditPosts.saved[indexPath.row]
        self.performSegue(withIdentifier: self.GO_TO_SPECIFIC_POST, sender: nil)
        
        
    }
}
