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
        let author_fullname: String
        let domain: String
        let title: String;
        let num_comments: Int
        let ups:   Int
        let downs: Int
        let created: Double
        let preview: ImagePreview
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

struct RedditPost {
    let author_fullname: String
    let domain: String
    let title: String;
    let num_comments: Int
    let rating: Int
    let images: [String]
    let time: Double
    var saved: Bool
}

// =========================================================

// NOTE: Only returns and error if JSONDecoder failed to decode.
//       Whitch mean that data passed in was invalid for decoding into RedditResponce
func getRedditUserPostsData(from data: Data) -> Result<[RedditPost], Error> {
    
    do {
        var responces = [RedditPost]()
        
        let rawRedditResponce = try JSONDecoder().decode(RawRedditResponce.self, from: data)
        
        for userPost in rawRedditResponce.data.children {
            let author_fullname = userPost.data.author_fullname
            let num_comments    = userPost.data.num_comments
            let domain = userPost.data.domain
            let title  = userPost.data.title
            let rating = userPost.data.ups - userPost.data.downs
            let images_invalid = userPost.data.preview.images.map{$0.source.url}
            let images_valid   = images_invalid.map {$0.replacingOccurrences(of: "&amp;", with: "&")}
            let time = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(userPost.data.created)))
            
            let responce = RedditPost(author_fullname: author_fullname, domain: domain, title: title, num_comments: num_comments, rating: rating, images: images_valid, time: time, saved: Bool.random())
            
            responces.append(responce)
        }
        return .success(responces)
    }
    catch {
        return .failure(error)
    }
}



func getRedditPosts() async -> [RedditPost] {
    let url        = "https://www.reddit.com/r/ios/top.json"
    let parameters = ["limit": "1"]
    
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


