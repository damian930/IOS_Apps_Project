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
    /*private*/ weak var vc: RedditPost_SingleTappable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSingleTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSingleTapGesture()
    }
    
    func configure(vc: RedditPost_SingleTappable) {
        self.vc = vc
    }
    
    private func addSingleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer()
        singleTapGesture.addTarget(self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)
        
        // TODO: remove the double tap from here, but cant do it now, since it throws an error in one of the views. Dont know why, those 2 have nothing to do with 1 another
        // Now i know, it throws it, cause 1 outler is not initilaised before used, its not that big of a deal, but th fact that this when removed result in that just doesnt make sense at all
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc private func handleSingleTap() {
        
        // Perform seque
        guard let vc = self.vc else {
            assert(false, "Trying to use a nil vc, not allowed")
        }
        guard let post = self.redditPostView.post else {
            assert(false, "Trying to use a nil redditPost, not allowed")
        }
        print("1")
        vc.singleTapHandler(post: post)


    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        

    }
    
}
