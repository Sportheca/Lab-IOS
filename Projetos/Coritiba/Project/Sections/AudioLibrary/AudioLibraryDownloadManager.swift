//
//  AudioLibraryDownloadManager.swift
//  
//
//  Created by Roberto Oliveira on 3/25/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct AudioLibraryDownloadInfo {
    var id:Int
    var urlString:String
    var progress:Float
}

class AudioLibraryDownloadManager: NSObject, URLSessionDownloadDelegate {
    
    // MARK: - Properties
    private var id:Int = 0
    private var urlString:String = ""
    
    
    
    // MARK: - Notifications
    static let notification_downloadProgressUpdated:String = "AudioLibraryDownloadManager_notification_downloadProgressUpdated"
    
    
    // MARK: - Session Properties
    private let configuration:URLSessionConfiguration = URLSessionConfiguration.default
    private let operationQueue = OperationQueue()
    private var urlSession:URLSession = URLSession()
    private var downloadTask:URLSessionDownloadTask = URLSessionDownloadTask()
    
    
    
    
    
    // MARK: - Methods
    func downloadFile(id:Int, urlString:String) {
        self.id = id
        self.urlString = urlString
        self.urlSession = URLSession(configuration: self.configuration, delegate: self, delegateQueue: self.operationQueue)
        guard let url = URL(string: urlString) else {return}
        self.sendNotification(progress: 0, notificationName: AudioLibraryDownloadManager.notification_downloadProgressUpdated)
        self.downloadTask = self.urlSession.downloadTask(with: url)
        self.downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var fileName = self.urlString.substringFrom(char: "/", at: .last, charIncluded: false)
        fileName = fileName.removingPercentEncoding?.removingPercentEncoding ?? fileName
        do {
            guard let audioUrl = URL(string: AudioLibraryManager.fileUrlString(sufix: self.urlString)) else {return}
            let folder = AudioLibraryManager.downloadsFolder()
            let destinationUrl = folder.appendingPathComponent(audioUrl.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                let _ = try FileManager.default.replaceItemAt(destinationUrl, withItemAt: location)
            } else {
                try FileManager.default.copyItem(at: location, to: destinationUrl)
            }
            AudioLibraryManager.shared.downloadingIds.remove(self.id)
            self.sendNotification(progress: 1.0, notificationName: AudioLibraryDownloadManager.notification_downloadProgressUpdated)
        } catch {
            // error
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let maxValue = min(percentage, 1)
        let progress = max(0, maxValue)
        guard progress < 1.0 else {return}
        DispatchQueue.main.async {
            self.sendNotification(progress: progress, notificationName: AudioLibraryDownloadManager.notification_downloadProgressUpdated)
        }
    }
    
    
    private func sendNotification(progress:Float, notificationName:String) {
        let item = AudioLibraryDownloadInfo(id: self.id, urlString: self.urlString, progress: progress)
        NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: item)
    }
    
}


