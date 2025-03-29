//
//  SavedRedditPosts.swift
//  hm_2
//
//  Created by  Damian  on 29.03.2025.
//

import Foundation

final class SavedRedditPosts {
    // TODO: make it accecible but not settable
    static var saved  = [RedditPost]()
    
//    static var loaded = [RedditPost]()
    
    static private let savedFolderName = "saved-reddit-posts"
    
    private init() {}
    
    static func save(_ post: RedditPost) {
        if saved.contains(where: { $0.id == post.id }) {
            assert(false, "Somehow post that was supposed to be saved is alredy saved")
        }
        
        saved.append(post)
    }
    
    static func unsave(_ post: RedditPost) {
        let prevSize = saved.count
        saved.removeAll(where: { $0.id == post.id })
        
        assert(saved.count + 1 == prevSize, "Somehow after deleting, the size of list of saved was not saved + 1 == prevSize. prevSize: \(prevSize), newSize: \(saved.count)")
        
    }
    
    //TODO: move it somewhere better
    static func createSavedFolder() {
        let fm = FileManager.default
        do {
            let docFiles = try fm.contentsOfDirectory(atPath: URL.documentsDirectory.path())
            if !docFiles.contains(savedFolderName) {
                var path = URL.documentsDirectory
                path.append(path: savedFolderName)
                fm.createFile(atPath: path.path(), contents: nil)
            }
//            else {
//                var path = URL.documentsDirectory
//                path.append(path: savedFolderName)
//                do {
//                    let str = try String(contentsOf: path)
//                }
//                catch {
//                    print(error)
//                }
//            }
        }
        catch {
            assert(false, "Some wrong with saved posts file creation, error: \(error)")
        }
    }
    
    static func writeToFile() {
        var jsonData: Data? = nil
        do {
            jsonData = try JSONEncoder().encode(saved)
        }
        catch {
            assert(false, "Error encoding saved posts into json, error: \(error)")
        }
        
        var path: URL? = nil
        do {
            path = URL.documentsDirectory
            path!.append(path: savedFolderName)
            try jsonData!.write(to: path!)
        }
        catch {
            assert(false, "Error writing json into file: \(String(describing: path)), error: \(error)")
        }
        
        print("Wrote to file")
        
    }
    
    static func readFromFile() {
        var path = URL.documentsDirectory
        path.append(path: savedFolderName)
        
        var contents: Data? = nil
        do {
            contents = try Data(contentsOf: path)
        }
        catch {
            assert(false, "Error reading from file, error: \(error)")
        }

        do {
            saved = try JSONDecoder().decode([RedditPost].self, from: contents!)
        }
        catch {
            assert(false, "Error decoding saved posts, error: \(error)")
        }
        
    }
    
}

// TODO: Load this from alredy saved files if exist, write into a file when thee app stops working
