//
//  RedditPostView.swift
//  hm_2
//
//  Created by  Damian  on 18.03.2025.
//

import UIKit

class RedditPostView: UIView {
    
    private let CONTENT_XIB_NAME = "RedditPostView"
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var username: UILabel!
    
    @IBOutlet private weak var time: UILabel!
    
    @IBOutlet private weak var domain: UILabel!
    
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBOutlet private weak var title: UILabel!
    
    @IBOutlet private weak var image: UIImageView!
    
    @IBOutlet private weak var rating: UILabel!
    
    @IBOutlet private weak var nComments: UILabel!
    
    @IBOutlet private weak var shareLabel: UILabel!
    
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
//        self.contentView.fixInView(self)
    }
    
    func update_synchronously(newRedditPost: RedditPost) {
        self.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")

        self.time.text = timeAgo(from: newRedditPost.time)

        self.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")

        self.title.text = newRedditPost.title

        if let image_url = newRedditPost.images.first {
            self.image.sd_setImage(with: URL(string: image_url))
        }

        self.rating.text = "\(newRedditPost.rating)"

        self.nComments.text = "\(newRedditPost.num_comments)"
    }
    
    func update_in_paralel(newRedditPost: RedditPost) {
        DispatchQueue.main.async {
            [weak self] in
            
            self?.username.text = truncateString(newRedditPost.author_fullname, maxLength: 13, prefix: "u/")

            self?.time.text = timeAgo(from: newRedditPost.time)

            self?.domain.text = truncateString(newRedditPost.domain, maxLength: 13, prefix: "")

            self?.title.text = newRedditPost.title

            if let image_url = newRedditPost.images.first {
                self?.image.sd_setImage(with: URL(string: image_url))
            }

            self?.rating.text = "\(newRedditPost.rating)"

            self?.nComments.text = "\(newRedditPost.num_comments)"
            
        }
    }
    
}


