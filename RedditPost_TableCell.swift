//
//  RedditPost_TableCell.swift
//  hm_2
//
//  Created by  Damian  on 18.03.2025.
//

import UIKit

class RedditPost_TableCell: UITableViewCell {
    
    static let identifier = "reddit post cell"

    @IBOutlet weak var redditPostView: RedditPostView!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "RedditPost_TableCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
