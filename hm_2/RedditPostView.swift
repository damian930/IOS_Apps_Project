//
//  RedditPostView.swift
//  hm_2
//
//  Created by  Damian  on 18.03.2025.
//

import UIKit

final class RedditPostView: UIView {
    
    private let CONTENT_XIB_NAME = "RedditPostView"
    
    // TODO: see if there is a better way to have it in here, cause having the whole ass post in the ui class doesnt seem good to me
    var redditPost: RedditPost?
    
    private weak var parentVC: PostList_ViewController?
        
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet private weak var username: UILabel!
    
    @IBOutlet private weak var time: UILabel!
    
    @IBOutlet private weak var domain: UILabel!
    
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBOutlet private weak var title: UILabel!
    
    @IBOutlet private weak var image: UIImageView!
    
    @IBOutlet private weak var rating: UILabel!
    
    @IBOutlet private weak var nComments: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    
    // Constraint from top of ("rating...") to the bottom of the image
    @IBOutlet private weak var rating_comments_share_ImageConstraint: NSLayoutConstraint!
    
    // Constraint from top of ("rating...") to the bottom of the title
    @IBOutlet private weak var rating_comments_share_TitleConstaint: NSLayoutConstraint!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        print(frame)
//
//        commonInit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(self.CONTENT_XIB_NAME, owner: self, options: nil)
        
        self.contentView.fixInView(self)
        
        shareButton.addTarget(nil, action: #selector(PostList_ViewController.openAcivityVC), for: .touchUpInside)
    }
    
    func update_synchronously(newRedditPost: RedditPost, vc: PostList_ViewController?) {
        self.redditPost = newRedditPost
        self.parentVC   = vc
        
        self.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")
        
        self.time.text = timeAgo(from: newRedditPost.time)
        
        self.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")
        
        self.title.text = newRedditPost.title
        
        handleImages(newRedditPost.images)
        
        self.rating.text = "\(newRedditPost.rating)"
        
        self.nComments.text = "\(newRedditPost.num_comments)"
        
        if newRedditPost.isSaved {
            self.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        else {
            self.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
    }
    
    func update_in_paralel_on_main(newRedditPost: RedditPost, vc: PostList_ViewController?) {
        self.redditPost = newRedditPost
        self.parentVC   = vc
        
        DispatchQueue.main.async {
            [weak self] in
            
            self?.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")
            
            self?.time.text = timeAgo(from: newRedditPost.time)
            
            self?.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")
            
            self?.title.text = newRedditPost.title
            
            self?.handleImages(newRedditPost.images)
            
            self?.rating.text = "\(newRedditPost.rating)"
            
            self?.nComments.text = "\(newRedditPost.num_comments)"
            
            if newRedditPost.isSaved {
                self?.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            else {
                self?.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    private func handleImages(_ images: [String]) {
        if images.isEmpty {
            DispatchQueue.main.async {
                [weak self] in
                self?.image.isHidden = true
                self?.rating_comments_share_ImageConstraint.isActive = false
                self?.rating_comments_share_TitleConstaint.isActive = true
            }
        }
        else {
            let imageURL = images[0]
            DispatchQueue.main.async {
                [weak self] in
                self?.image.sd_setImage(with: URL(string: imageURL))
            }
        }
    }
    
    @IBAction private func savedButtonPressed(_ sender: UIButton) {
        // Updating the button image
        DispatchQueue.main.async {
            [weak self] in
            self?.updateBookmarkButton()
        }
        
    }
    
    private func updateBookmarkButton() {
        guard var post = self.redditPost else {
            assert(false, "Empty reddit post when trying to save a post")
        }
        
        if !post.isSaved {
            post.isSaved = true
            self.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            SavedRedditPosts.save(post)
            
            print("Saved a post -> ID: \(post.id), title: \(post.title)")
        } else {
            post.isSaved = false
            self.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            SavedRedditPosts.unsave(post)
            
            print("Unsaved a post -> ID: \(post.id), title: \(post.title)")
        }
        
        self.redditPost = post
        
        
        
//        print(String(describing: self.redditPost?.title))
//        print(String(describing: self.redditPost?.isSaved))
//        print("")
        
        // Store it into the documents floder
        // Plan:
        // 0. Create a global list of alredy saved posts
        // 1. Have post to save
        // 2. Make a json out of that post
        // 3. Add post to saved posts
        // 4. When app life cycle ends, create a new json from global saved
        // 5. Write global saved into a file
        
        // 6. When opening up the app, load the saved posts from json into a global var.

    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let parentVC = self.parentVC, let redditPost = self.redditPost else {
            assert(false, "Using nil values")
        }
        
        parentVC.sharePost(redditPost)
    }
}





