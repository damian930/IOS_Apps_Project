//
//  RedditPostView.swift
//  hm_2
//
//  Created by  Damian  on 18.03.2025.
//

import UIKit

final class RedditPostView: UIView {
    
    private let CONTENT_XIB_NAME = "RedditPostView"
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet private weak var username: UILabel!
    
    @IBOutlet private weak var time: UILabel!
    
    @IBOutlet private weak var domain: UILabel!
    
    @IBOutlet private weak var saveButton: UIButton!
    
    private var isSaved = false
    
    @IBOutlet private weak var title: UILabel!
    
    @IBOutlet private weak var image: UIImageView!
    
    @IBOutlet private weak var rating: UILabel!
    
    @IBOutlet private weak var nComments: UILabel!
    
    @IBOutlet private weak var shareLabel: UILabel!
    
    // Constraint from top of rating... to the bottom of the image
    @IBOutlet private weak var rating_comments_share_ImageConstraint: NSLayoutConstraint!
    
    // Constraint from top of rating... to the bottom of the title
    @IBOutlet private weak var rating_comments_share_TitleConstaint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(self.CONTENT_XIB_NAME, owner: self, options: nil)
        
        self.contentView.fixInView(self)
    }
    
    func update_synchronously(newRedditPost: RedditPost) {
        self.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")
        
        self.time.text = timeAgo(from: newRedditPost.time)
        
        self.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")
        
        self.title.text = newRedditPost.title
        
        handleImages(newRedditPost.images)
        
        self.rating.text = "\(newRedditPost.rating)"
        
        self.nComments.text = "\(newRedditPost.num_comments)"
        
        if newRedditPost.saved {
            self.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        else {
            self.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
    }
    
    func update_in_paralel_on_main(newRedditPost: RedditPost) {
        DispatchQueue.main.async {
            [weak self] in
            
            self?.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")
            
            self?.time.text = timeAgo(from: newRedditPost.time)
            
            self?.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")
            
            self?.title.text = newRedditPost.title
            
            self?.handleImages(newRedditPost.images)
            
            self?.rating.text = "\(newRedditPost.rating)"
            
            self?.nComments.text = "\(newRedditPost.num_comments)"
            
            if newRedditPost.saved {
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
        self.isSaved.toggle()
        DispatchQueue.main.async {
            [weak self] in
            self?.updateBookmarkButton()
        }
        
    }
    
    private func updateBookmarkButton() {
        // Changing the button image
        if self.isSaved {
            self.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            self.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}





