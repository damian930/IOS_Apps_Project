//
//  AdditionalFunctions.swift
//  hm_2
//
//  Created by  Damian  on 18.03.2025.
//

import Foundation
import UIKit

// Used for controller
// Reddit post can be shared, but it might be neted into a table
// If it is, then we need to know where to open the ActivityView from within the RedditPostView
// So we store a pointer to the Controller at whitch the RedditPost is nesting, to be able to share, those controller are to be Shaerable.
// So use this protocol
protocol RedditPost_Shaerable: AnyObject {
    func sharePost(_ post: RedditPost)
}

protocol RedditPost_SingleTappable: AnyObject {
    func singleTapHandler(post: RedditPost)
}

protocol RedditPost_DoubleTappable: AnyObject {
    func doubleTapHandler(post: RedditPost)
}

extension UIView {
    func fixInView(_ container: UIView!)  {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}

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
