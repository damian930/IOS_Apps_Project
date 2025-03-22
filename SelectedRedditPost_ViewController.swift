//
//  SelectedRedditPost_ViewController.swift
//  hm_2
//
//  Created by  Damian  on 22.03.2025.
//

import UIKit

final class SelectedRedditPost_ViewController: UIViewController {

    @IBOutlet private weak var redditPostView: RedditPostView!
    
    func configureSync(redditPost: RedditPost) {
        self.redditPostView.update_synchronously(newRedditPost: redditPost)
    }

}
