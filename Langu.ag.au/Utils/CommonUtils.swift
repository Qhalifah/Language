//
//  CommonUtils.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation
import SystemConfiguration


class CommonUtils{

    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    static func getRandomNumber(_ maxValue : Int) -> Int{
        return Int(arc4random_uniform(UInt32(maxValue)))
    }

    // this function works for get jumbled items and other functions to show learning page
    static func getRandomizedObject(from originalObjects: [AnyObject]) -> [AnyObject]{
        let count = originalObjects.count

        var result : [AnyObject] = []
        var workingObject = originalObjects
        for index in 0..<count{
            let currentIndex = getRandomNumber(count - index)
            result.append(workingObject[currentIndex])
            workingObject.remove(at: currentIndex)
        }
        return result
    }

    static func getLessonItemsObject(from originalObject: [AnyObject]) -> [AnyObject]{
        var result:[AnyObject] = []

        //standard learning items are added by their order
        for index in 0..<Int(originalObject.count / 3){
            result.append(originalObject[index])
        }

        var randomizedObjects:[AnyObject] = []
        for index in Int(originalObject.count / 3)..<originalObject.count{
            randomizedObjects.append(originalObject[index])
        }

        for resultObject in getRandomizedObject(from: randomizedObjects){
            result.append(resultObject)
        }
        return result
    }

    static func getLocalDirectories() -> [[String: String]]{
        var resultArray:[[String: String]] = []
        var directoryObject:[String: String] = [:]
        let imageFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Images")
        directoryObject[Constants.KEY_DIRECTROY_NAME] = imageFileUrl.absoluteString
        directoryObject[Constants.KEY_DIRECTORY_SIZE] = String(format: "%.2lf MB", Double(getSizeOfUrl(imageFileUrl)) / 1024.0 / 1024.0)
        resultArray.append(directoryObject)
        
        let audioFilesUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Audio")
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: audioFilesUrl, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:

            for directory in directoryContents{
                /*guard let directoryEnumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: nil) else{
                    continue
                }*/
                directoryObject = [:]
                
                
                if "\(directory)".contains(Constants.TALK_NOW_PREFIX)
                {
                    directoryObject[Constants.KEY_DIRECTORY_SIZE] = String(format: "%.2lf MB", Double(getSizeOfUrl(directory)) / 1024.0 / 1024.0)
                    
                    directoryObject[Constants.KEY_DIRECTROY_NAME] = "\(directory)"
                    resultArray.append(directoryObject)
                }
                else {
                    continue
                }
                
            }
            return resultArray

            
        } catch _ {
            return []
        }
    }
    
    static func getSizeOfUrl(_ url: URL) -> UInt64{
        // get your directory url
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            var folderFileSizeInBytes: UInt64 = 0
            for file in files {
                
                //let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
                if !isDirectory(file){
                    folderFileSizeInBytes += (try? FileManager.default.attributesOfItem(atPath: file.path)[.size] as? NSNumber)??.uint64Value ?? 0
                }
                else
                {
                    folderFileSizeInBytes += getSizeOfUrl(file)
                }
            }
            
            // format it using NSByteCountFormatter to display it properly
            /*let  byteCountFormatter =  ByteCountFormatter()
            byteCountFormatter.allowedUnits = .useBytes
            byteCountFormatter.countStyle = .file
            let folderSizeToDisplay = byteCountFormatter.string(fromByteCount: Int64(folderFileSizeInBytes))*/
            return folderFileSizeInBytes
            
        } catch _{
            return 0
        }

    }
    
    static func isDirectory(_ url: URL) -> Bool{
        
        
        do{
            let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            if files.count > 0{
                return true
            }
            else{
                return false
            }
        }
        catch _ {
            
            return false
        }
    }
    
    
    
    static func getFilenameFrom(_ url: String) -> String{
        var nameStringArray = url.components(separatedBy: "/")
        //var result = ""
        var lastString = nameStringArray[nameStringArray.count - 1]
        if lastString.characters.count > 0{
            return lastString
        }
        else{
            return nameStringArray[nameStringArray.count - 2]
        }
    }
    
    static func removeFile(_ filename: String) -> Bool{
    
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: URL(string: filename)!)
        }
        catch _ {
            
        }
        /*
        if (fileManager.fileExists(atPath: filename)) {
            do {
                try fileManager.removeItem(atPath: filename)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
                return false
            }
        }*/
        return true
    }
    
    
    

    
}


