//
//  ViewController.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var redditPosts = [RedditPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(RedditPost_TableCell.nib(), forCellReuseIdentifier: RedditPost_TableCell.identifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
        Task {
            
            self.redditPosts = await getRedditPosts(limit: 4)
            
            self.tableView.reloadData()
            
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.redditPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditPost_TableCell.identifier, for: indexPath) as! RedditPost_TableCell
        
        let redditPost = self.redditPosts[indexPath.item]
        cell.redditPostView.update_synchronously(newRedditPost: redditPost)
        
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






