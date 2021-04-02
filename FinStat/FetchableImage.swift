//
//  FetchableImage.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/28/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

// Used code from https://www.appcoda.com/fetch-remote-images-swift/

import Foundation

protocol FetchableImage {
    func localFileURL(for imageURL: String?, options: FetchableImageOptions?) -> URL?
    
    func fetchImage(from urlString: String?, options: FetchableImageOptions?, completion: @escaping (_ imageData: Data?) -> Void)
}

extension FetchableImage {
    func localFileURL(for imageURL: String?, options: FetchableImageOptions? = nil) -> URL? {
        let opt = FetchableImageHelper.getOptions(options)
        
        let targetDir = opt.storeInCachesDirectory ?
            FetchableImageHelper.cachesDirectoryURL :
            FetchableImageHelper.documentsDirectoryURL
        
        guard let urlString = imageURL else {
         guard let customFileName = opt.customFileName else { return nil }
         return targetDir.appendingPathComponent(customFileName)
        }
        
        guard let imageName = FetchableImageHelper.getImageName(from: urlString) else { return nil }
        
        return targetDir.appendingPathComponent(imageName)
    }
    
    func fetchImage(from urlString: String?, options: FetchableImageOptions? = nil, completion: @escaping (_ imageData: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let opt = FetchableImageHelper.getOptions(options)
            let localURL = self.localFileURL(for: urlString, options: options)
            if opt.allowLocalStorage,
                let localURL = localURL,
                FileManager.default.fileExists(atPath: localURL.path) {
                    let loadedImageData = FetchableImageHelper.loadLocalImage(from: localURL)
                    completion(loadedImageData)
            } else {
                guard let urlString = urlString, let url = URL(string: urlString) else {
                    completion(nil)
                    return
                }
                FetchableImageHelper.downloadImage(from: url) { (imageData) in
                    if opt.allowLocalStorage, let localURL = localURL {
                        try? imageData?.write(to: localURL)
                    }
                    completion(imageData)
                }
            }
        }
    }
}

struct FetchableImageOptions {
    var storeInCachesDirectory: Bool = true
    var allowLocalStorage: Bool = true
    var customFileName: String?
}

fileprivate struct FetchableImageHelper {
     static var documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static var cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    static func getOptions(_ options: FetchableImageOptions?) -> FetchableImageOptions {
    return options != nil ? options! : FetchableImageOptions()
    }
    
    static func getImageName(from urlString: String) -> String? {
     guard var base64String = urlString.data(using: .utf8)?.base64EncodedString() else { return nil }
        base64String = base64String.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        guard base64String.count < 50 else {
            return String(base64String.dropFirst(base64String.count - 50))
        }
        return base64String
    }
    static func downloadImage(from url: URL, completion: @escaping (_ imageData: Data?) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(data)
        }
        task.resume()
    }
    
    static func loadLocalImage(from url: URL) -> Data? {
        do {
            let imageData = try Data(contentsOf: url)
            return imageData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
