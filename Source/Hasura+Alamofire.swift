
//  HTTPManager.swift
//  Hasura
//
//  Created by Jaison on 27/06/17.
//  Copyright © 2017 Hasura. All rights reserved.


import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public struct HasuraDownloadFileRequest {
    
    var downloadRequest: DownloadRequest
    var destinationURL: URL
    
    public func response(callbackHandler: @escaping (Data?,Double, HasuraError?) -> Void) {
        
        print("Request")
        print(downloadRequest.debugDescription)
        
        downloadRequest
            .downloadProgress(closure: { (progress) in
                let progressCompletion = progress.fractionCompleted
                callbackHandler(nil,progressCompletion*100, nil)
            })
            .responseData { (response) in
                
                print("Response")
                print(response.debugDescription)
                
                switch (response.result) {
                case .success(let data) :
                    callbackHandler(data, 100, nil)
                    break
                case .failure(let error):
                    callbackHandler(nil, -1, error.getHasuraError())
                    break
                }
        }
    }
}

public struct HasuraUploadFileRequest {
    
    var uploadRequest: UploadRequest
    
    init(request: UploadRequest) {
        self.uploadRequest = request
    }
    
    public func response(callbackHandler: @escaping(FileUploadResponse?, HasuraError?) -> Void) {
        print("Request")
        print(uploadRequest.debugDescription)
        
        uploadRequest
            .validate()
            .responseObject { (response: DataResponse<FileUploadResponse>) in
                print("Response")
                print(response.debugDescription)
                if let data = response.data {
                    print(data.toString())
                }
        }
    }
    
}

public struct HasuraDataRequest {
    
    var dataRequest: DataRequest
    
    init(request: DataRequest) {
        self.dataRequest = request
    }
    
    public func responseObject<T: Mappable>(queue: DispatchQueue? = nil, callbackHandler: @escaping (T?, HasuraError?) -> Void) {
        
        print(dataRequest.debugDescription)
        
        dataRequest
            .validate()
            .responseObject { (response: DataResponse<T>) in
                
                print(response.debugDescription)
                if let data = response.data {
                    print(data.toString())
                }
                
                switch(response.result) {
                case .success(let value) :
                    callbackHandler(value, nil)
                    break
                case .failure(let error):
                    callbackHandler(nil, error.getHasuraError())
                    break
                }
        }
    }
    
    public func responseArray<T: Mappable>(queue: DispatchQueue? = nil, callbackHandler: @escaping ([T]?, HasuraError?) -> Void) {
        
        print("Request")
        print(dataRequest.debugDescription)
        
        dataRequest.validate()
            .responseArray { (response: DataResponse<[T]>) in
                
                print("Response")
                print(response.debugDescription)
                if let data = response.data {
                    print("Data Exists")
                    let jsonString = String(data: data, encoding: .utf8)
                    print(jsonString ?? "No String for data ")
                    
                }
                
                switch(response.result) {
                case .success(let value) :
                    callbackHandler(value, nil)
                    break
                case .failure(let error):
                    callbackHandler(nil, error.getHasuraError())
                    break
                }
        }
    }
    
}

public class HTTPManager {
    
    @discardableResult
    public static func request(
        url: String,
        httpMethod: HTTPMethod = .get,
        params: JSON? = nil,
        headers: HTTPHeaders? = nil
        ) -> HasuraDataRequest {
        
        return HasuraDataRequest(request: Alamofire.request(url, method: httpMethod, parameters: params, encoding: JSONEncoding.default, headers: headers))
    }
    
    @discardableResult
    public static func upload(
        url: String,
        data: Data,
        headers: HTTPHeaders? = nil
        ) -> HasuraUploadFileRequest {
        
        return HasuraUploadFileRequest(request: Alamofire.upload(data, to: url, method: HTTPMethod.post, headers: headers))
    }
    
    @discardableResult
    public static func download(
        url: String,
        headers: HTTPHeaders? = nil
        ) -> HasuraDownloadFileRequest {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent(url)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return HasuraDownloadFileRequest(downloadRequest: Alamofire.download(url, method: .get, headers: headers, to: destination), destinationURL: fileURL)
    }
    
}
