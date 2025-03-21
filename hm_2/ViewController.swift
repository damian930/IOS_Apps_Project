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
    
    @IBOutlet private weak var postsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTable.rowHeight          = UITableView.automaticDimension
        self.postsTable.estimatedRowHeight = 400
        
        //        Run time error
        //        self.postsTable.register(RedditPost_TableCell.self, forCellReuseIdentifier: self.CELL_ID)
        
        self.postsTable.dataSource = self
        self.postsTable.delegate   = self
        
        Task {
            
            self.redditPosts = await getRedditPosts(limit: 3)
            
            self.postsTable.reloadData()
            
    
        }
        
    }

    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.redditPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! RedditPost_TableCell
        
        let redditPost = self.redditPosts[indexPath.item]
        cell.redditPostView.update_in_paralel_on_main(newRedditPost: redditPost)
        
        return cell
        
    }
    
}

extension ViewController: UITableViewDelegate {
    
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






