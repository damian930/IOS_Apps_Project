//
//  RedditPost_TableCell.swift
//  hm_2
//
//  Created by  Damian  on 21.03.2025.
//

import UIKit

final class RedditPost_TableCell: UITableViewCell {

    @IBOutlet weak var redditPostView: RedditPostView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
