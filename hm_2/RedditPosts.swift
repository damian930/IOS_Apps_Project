//
//  RedditPosts.swift
//  hm_2
//
//  Created by  Damian  on 9.03.2025.
//

import Foundation

struct RawRedditResponce: Codable {
    let data: HeadingData
    
    struct HeadingData: Codable {
        let children: [Children]
    }
    
    struct Children: Codable {
        let data: UserPost
    }
    
    struct UserPost: Codable {
        let name: String
        let author_fullname: String
        let domain: String
        let title: String;
        let num_comments: Int
        let ups:   Int
        let downs: Int
        let created: Double
        let preview: ImagePreview?
    }
    
    struct ImagePreview: Codable {
        let images: [Image]
    }
    
    struct Image: Codable {
        let source: ImageSource
    }
    
    struct ImageSource: Codable {
        let url: String
    }
}

// =========================================================

final class RedditPost: Codable, Equatable {
    static func == (lhs: RedditPost, rhs: RedditPost) -> Bool {
        return lhs.id == rhs.id &&
                       lhs.domain == rhs.domain &&
                       lhs.title == rhs.title &&
                       lhs.rating == rhs.rating &&
                       lhs.images == rhs.images &&
                       lhs.time == rhs.time &&
                       lhs.isSaved == rhs.isSaved &&
                       lhs.author_fullname == rhs.author_fullname &&
                       lhs.num_comments == rhs.num_comments
    }
    
    let id     : String
    let domain : String
    let title  : String;
    let rating : Int
    let images : [String]
    let time   : Double
    var isSaved: Bool
    let author_fullname: String
    let num_comments   : Int
    
    init(id: String, domain: String, title: String, rating: Int, images: [String], time: Double, isSaved: Bool, author_fullname: String, num_comments: Int) {
        self.id      = id
        self.domain  = domain
        self.title   = title
        self.rating  = rating
        self.images  = images
        self.time    = time
        self.isSaved = isSaved
        self.author_fullname = author_fullname
        self.num_comments    = num_comments
    }
}

// =========================================================

// NOTE: Only returns and error if JSONDecoder failed to decode.
//       Whitch means that data passed in was invalid for decoding into RedditResponce
func getRedditUserPostsData(from data: Data) -> Result<[RedditPost], Error> {
    
    do {
        var responces = [RedditPost]()
        
        let rawRedditResponce = try JSONDecoder().decode(RawRedditResponce.self, from: data)
        
        for userPost in rawRedditResponce.data.children {
            let id = userPost.data.name
            let author_fullname = userPost.data.author_fullname
            let num_comments    = userPost.data.num_comments
            let domain = userPost.data.domain
            let title  = userPost.data.title
            let rating = userPost.data.ups - userPost.data.downs
            let images_invalid = userPost.data.preview?.images.map{$0.source.url}
            let images_valid   = images_invalid?.map {$0.replacingOccurrences(of: "&amp;", with: "&")}
            let time = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(userPost.data.created)))
            
            let responce = RedditPost(id: id, domain: domain, title: title, rating: rating, images: images_valid ?? [], time: time, isSaved: false, author_fullname: author_fullname, num_comments: num_comments)
            
            responces.append(responce)
        }
        return .success(responces)
    }
    catch {
        return .failure(error)
    }
}



func getRedditPosts(limit: Int, after: String = "") async -> [RedditPost] {
    let url        = "https://www.reddit.com/r/ios/top.json"
    let parameters = ["limit": "\(limit)", "after": after]
    
    let result = await betterWayToRetrieve(url: url, parameters: parameters)
    
    switch result {
        
    // UNHANDLED: Dont know what happends if the subreddit has 0 posts, should be nil at that point, dont know how to check what the api returns if no posts have ever been posted
    case .success(let data):
        let redditPosts = getRedditUserPostsData(from: data)
        
        switch redditPosts {
            
        case .success(let redditPosts):
            return redditPosts
            
        case .failure(let error):
            // Asserted if the JSONDecoder logic is not valid
            assert(false, error.localizedDescription)
        }
        
    case .failure(let error):
        // Asserted if the hard coded URL doesnt work or the API doesnt work
        assert(false, error.localizedDescription)
    }
    
    
}


