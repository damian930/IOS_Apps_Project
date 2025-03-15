//
//  ViewController.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet private weak var redditPostUsername: UILabel!
    
    @IBOutlet private weak var redditPostTime: UILabel!
    
    @IBOutlet private weak var redditPostDomain: UILabel!
    
    @IBOutlet private weak var redditPostTitle: UILabel!
    
    @IBOutlet private weak var redditPostImage: UIImageView!
    
    @IBOutlet private weak var redditPostRating: UILabel!
    
    @IBOutlet private weak var redditPostNComments: UILabel!
    
    @IBOutlet private weak var redditPostSaveButton: UIButton!
    
    private var currentPost: RedditPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            // Retrive the newest reddit post
            let redditPosts: [RedditPost] = await getRedditPosts()
            let firstPost = redditPosts[0]
            self.currentPost = firstPost
            
            // UI changes go here
            DispatchQueue.main.async {
                [weak self] in
                self?.updateUI(for: firstPost)
                
            }
            
        }
        
    }
    
    private func updateUI(for post: RedditPost) {
        // Loading the username
        self.redditPostUsername.text = truncateString(post.author_fullname, maxLength: 13, prefix: "u/")
        
        // Loading the time
        self.redditPostTime.text = timeAgo(from: post.time)
        
        // Loading the domain
        self.redditPostDomain.text = truncateString(post.domain, maxLength: 13, prefix: "")
        
        // Loading the title
        self.redditPostTitle.text = post.title
        
        // Loading an image
        if let image_url = post.images.first {
            self.redditPostImage.sd_setImage(with: URL(string: image_url))
        }
        
        // Loading the rating
        self.redditPostRating.text = "\(post.rating)"
        
        // Loading the number of comments
        self.redditPostNComments.text = "\(post.num_comments)"
        
        // Updating the bookmark button
        self.updateBookmarkButton(isSaved: post.saved)
    }
    
    @IBAction func savedButtonPressed(_ sender: UIButton) {
        // Unwrapping optional post and saving state for logging
        guard var post = currentPost else { return }
        let prevState  = post.saved
        
        // Updating the button image
        post.saved.toggle()
        self.currentPost = post
        updateBookmarkButton(isSaved: post.saved)
        
        print("Bookmark cahnged from \(prevState) to \(self.currentPost?.saved as Any)")
    }
    
    private func updateBookmarkButton(isSaved: Bool) {
        // Changing the button image
        if isSaved {
            self.redditPostSaveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            self.redditPostSaveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
}

// extra functionality

// Truncates the given string and also add an optinal prefix
func truncateString(_ str: String, maxLength: Int, prefix: String) -> String {
    if str.count <= maxLength {
        return "\(prefix)\(str)"
    }
    else {
        return "\(prefix)\(str.prefix(maxLength)).."
    }
}

// Maps timeInterval into a String (YouTube style release date)
func timeAgo(from timeInterval: TimeInterval) -> String {
    // Time diff in seconds
    let difference = Int(timeInterval)
    
    // Every other time measurement in seconds
    let minute = 60
    let hour   = 60 * minute
    let day    = 24 * hour
    let month  = 30 * day
    let year   = 365 * day
    
    // Creating a string 
    switch difference {
    case 0..<hour:
        return "\(difference / minute)m ago"
    case hour..<day:
        return "\(difference / hour)h ago"
    case day..<month:
        return "\(difference / day) days ago"
    case month..<year:
        return "\(difference / month) months ago"
    default:
        return "\(difference / year) years ago"
    }
}













