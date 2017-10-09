//
//  ABSRequestMultipartFormData.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import Alamofire

public protocol ABSRequestMultipartFormDataItem {
    
    func append(to multipartFormData: MultipartFormData)
    
}

public protocol ABSRequestMultipartFormDataDelegate: class {
    
    func progress(_ progress: Progress)
    
}

open class ABSRequestMultipartFormData {
    
    private var multipartFromDataItems = [ABSRequestMultipartFormDataItem]()
    
    // choose one style
    // delegate style
    public weak var delegate: ABSRequestMultipartFormDataDelegate?
    // closure style
    public var progressCallback: ((Progress)->())?
    
    public init() {}
    
    public init(_ multipartFromDataItems: [ABSRequestMultipartFormDataItem]) {
        self.multipartFromDataItems = multipartFromDataItems
    }
    
    @discardableResult
    public func append(_ item: ABSRequestMultipartFormDataItem) -> ABSRequestMultipartFormData {
        self.multipartFromDataItems.append(item)
        return self
    }
    
    @discardableResult
    public func progressCallback(_ progressCallback: ((Progress)->())?) -> ABSRequestMultipartFormData {
        self.progressCallback = progressCallback
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: ABSRequestMultipartFormDataDelegate?) -> ABSRequestMultipartFormData {
        self.delegate = delegate
        return self
    }
    
    public func getMultipartFromDataItems() -> [ABSRequestMultipartFormDataItem] {
        return self.multipartFromDataItems
    }
    
    public func progress(_ progress: Progress) {
        if let theDelegate = self.delegate {
            theDelegate.progress(progress)
        } else if let theProgressCallback = self.progressCallback {
            theProgressCallback(progress)
        }
    }
    
}

open class ABSRequestMultipartFormDataString: ABSRequestMultipartFormDataItem {
    
    private var name: String
    private var content: String
    
    public init(name: String, content: String) {
        self.name = name
        self.content = content
    }
    
    public func append(to multipartFormData: MultipartFormData) {
        if let theData = self.content.data(using: .utf8) {
            multipartFormData.append(theData, withName: self.name)
        }
    }
    
}

open class ABSRequestMultipartFormDataDict: ABSRequestMultipartFormDataItem {
    private var key: String
    private var dict: [String:Any]
    
    public init(key: String, dict: [String:Any]) {
        self.key = key
        self.dict = dict
    }
    
    public func append(to multipartFormData: MultipartFormData) {
        if let theData = ABSUtils.toData(from: self.dict) {
            multipartFormData.append(theData, withName: self.key)
        }
    }
}

// just can resolve first layer key
open class ABSRequestMultipartFormDataMultiKeysDict: ABSRequestMultipartFormDataItem {
    
    private var dict: [String: Any]
    
    public init(dict: [String: Any]) {
        self.dict = dict
    }
    
    public func append(to multipartFormData: MultipartFormData) {
        for (k, v) in self.dict {
            if v is [String: Any] || v is [Any] {
                if let theData = ABSUtils.toData(from: v) {
                    multipartFormData.append(theData, withName: k)
                }
            } else if let theData = "\(v)".data(using: .utf8) {
                multipartFormData.append(theData, withName: k)
            }
        }
    }
    
}

open class ABSRequestMultipartFormDataData: ABSRequestMultipartFormDataItem {
    private var data: Data
    private var name: String
    private var fileName: String
    private var mimeType: String
    
    public init(name: String, data: Data, fileName: String, mimeType: String? = nil) {
        self.name = name
        self.data = data
        self.fileName = fileName
        if let theMimeType = mimeType {
            self.mimeType = theMimeType
        } else {
            self.mimeType = ABSMimeType(name: fileName).value
        }
    }
    
    public func append(to multipartFormData: MultipartFormData) {
        multipartFormData.append(self.data, withName: self.name, fileName: self.fileName, mimeType: self.mimeType)
    }
    
}

open class ABSRequestMultipartFormDataFileURL: ABSRequestMultipartFormDataItem {
    
    private var fileURL: URL
    private var name: String
    private var fileName: String?
    private var mimeType: String?
    
    public init(name: String, fileURL: URL, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.fileURL = fileURL
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public func append(to multipartFormData: MultipartFormData) {
        if let theFileName = self.fileName, let theMimeType = self.mimeType, !theFileName.isEmpty, !theMimeType.isEmpty {
            multipartFormData.append(self.fileURL, withName: self.name, fileName: theFileName, mimeType: theMimeType)
        } else {
            multipartFormData.append(self.fileURL, withName: self.name)
        }
    }
    
}

public struct ABSMimeType {
    
    let ext: String?
    
    public var value: String {
        guard let ext = ext else {
            return ABSMimeType.DEFAULT_MIME_TYPE
        }
        return ABSMimeType.mimeTypes[ext.lowercased()] ?? ABSMimeType.DEFAULT_MIME_TYPE
    }
    
    public init(path: String) {
        ext = NSString(string: path).pathExtension
    }
    
    public init(name: String) {
        ext = NSString(string: name).pathExtension
    }
    
    public init(path: NSString) {
        ext = path.pathExtension
    }
    
    public init(url: URL) {
        ext = url.pathExtension
    }
    
    static let DEFAULT_MIME_TYPE = "application/octet-stream"
    static let mimeTypes = [
        "html": "text/html",
        "htm": "text/html",
        "shtml": "text/html",
        "css": "text/css",
        "xml": "text/xml",
        "gif": "image/gif",
        "jpeg": "image/jpeg",
        "jpg": "image/jpeg",
        "js": "application/javascript",
        "atom": "application/atom+xml",
        "rss": "application/rss+xml",
        "mml": "text/mathml",
        "txt": "text/plain",
        "jad": "text/vnd.sun.j2me.app-descriptor",
        "wml": "text/vnd.wap.wml",
        "htc": "text/x-component",
        "png": "image/png",
        "tif": "image/tiff",
        "tiff": "image/tiff",
        "wbmp": "image/vnd.wap.wbmp",
        "ico": "image/x-icon",
        "jng": "image/x-jng",
        "bmp": "image/x-ms-bmp",
        "svg": "image/svg+xml",
        "svgz": "image/svg+xml",
        "webp": "image/webp",
        "woff": "application/font-woff",
        "jar": "application/java-archive",
        "war": "application/java-archive",
        "ear": "application/java-archive",
        "json": "application/json",
        "hqx": "application/mac-binhex40",
        "doc": "application/msword",
        "pdf": "application/pdf",
        "ps": "application/postscript",
        "eps": "application/postscript",
        "ai": "application/postscript",
        "rtf": "application/rtf",
        "m3u8": "application/vnd.apple.mpegurl",
        "xls": "application/vnd.ms-excel",
        "eot": "application/vnd.ms-fontobject",
        "ppt": "application/vnd.ms-powerpoint",
        "wmlc": "application/vnd.wap.wmlc",
        "kml": "application/vnd.google-earth.kml+xml",
        "kmz": "application/vnd.google-earth.kmz",
        "7z": "application/x-7z-compressed",
        "cco": "application/x-cocoa",
        "jardiff": "application/x-java-archive-diff",
        "jnlp": "application/x-java-jnlp-file",
        "run": "application/x-makeself",
        "pl": "application/x-perl",
        "pm": "application/x-perl",
        "prc": "application/x-pilot",
        "pdb": "application/x-pilot",
        "rar": "application/x-rar-compressed",
        "rpm": "application/x-redhat-package-manager",
        "sea": "application/x-sea",
        "swf": "application/x-shockwave-flash",
        "sit": "application/x-stuffit",
        "tcl": "application/x-tcl",
        "tk": "application/x-tcl",
        "der": "application/x-x509-ca-cert",
        "pem": "application/x-x509-ca-cert",
        "crt": "application/x-x509-ca-cert",
        "xpi": "application/x-xpinstall",
        "xhtml": "application/xhtml+xml",
        "xspf": "application/xspf+xml",
        "zip": "application/zip",
        "bin": "application/octet-stream",
        "exe": "application/octet-stream",
        "dll": "application/octet-stream",
        "deb": "application/octet-stream",
        "dmg": "application/octet-stream",
        "iso": "application/octet-stream",
        "img": "application/octet-stream",
        "msi": "application/octet-stream",
        "msp": "application/octet-stream",
        "msm": "application/octet-stream",
        "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "mid": "audio/midi",
        "midi": "audio/midi",
        "kar": "audio/midi",
        "mp3": "audio/mpeg",
        "ogg": "audio/ogg",
        "m4a": "audio/x-m4a",
        "ra": "audio/x-realaudio",
        "3gpp": "video/3gpp",
        "3gp": "video/3gpp",
        "ts": "video/mp2t",
        "mp4": "video/mp4",
        "mpeg": "video/mpeg",
        "mpg": "video/mpeg",
        "mov": "video/quicktime",
        "webm": "video/webm",
        "flv": "video/x-flv",
        "m4v": "video/x-m4v",
        "mng": "video/x-mng",
        "asx": "video/x-ms-asf",
        "asf": "video/x-ms-asf",
        "wmv": "video/x-ms-wmv",
        "avi": "video/x-msvideo"
    ]
}
