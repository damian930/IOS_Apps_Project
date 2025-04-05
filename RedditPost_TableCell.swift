//
//  RedditPost_TableCell.swift
//  hm_2
//
//  Created by  Damian  on 21.03.2025.
//

import UIKit

final class RedditPost_TableCell: UITableViewCell {
    
    @IBOutlet weak var redditPostView: RedditPostView!
    
//    TODO: maybe use a trait, something like cell tappable and cell double tappable
    private weak var vc: PostList_ViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSingleAndDoubleTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSingleAndDoubleTapGesture()
    }
    
    func configure(vc: PostList_ViewController) {
        self.vc = vc
    }
    
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        print("\n\tCell was single tapped\n")
        
        // Perform seque
        guard let vc = self.vc else {
            assert(false, "Trying to use a nil vc, not allowed")
        }
        guard let post = self.redditPostView.post else {
            assert(false, "Trying to use a nil redditPost, not allowed")
        }
        vc.openPost(post)
        
        
    }
    
    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("\n\tCell was double tapped\n")
        
        // Perform a like animation and save the post
        
    }
    
}
