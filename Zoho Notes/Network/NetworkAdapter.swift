//
//  NetworkAdapter.swift


import Foundation

class NetworkAdapter {
   
    
    static func clientNetworkRequestCodable(withBaseURL baseURL: String, withParameters parameters: String, withHttpMethod httpMethod: String, withContentType contentType: String, completionHandler: @escaping (_ responseData: Data?,_ showPopUp: Bool?,_ errorMessage: String?, String?) -> Void ) {
        
        var requestURL: URL?
        var session = URLSession.shared
        var urlRequest: URLRequest?
        let sessionDelegate: URLSessionDataDelegate = SessionDelegate()
        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.timeoutIntervalForRequest = TimeInterval(200)
        urlConfiguration.timeoutIntervalForResource = TimeInterval(200)
        urlConfiguration.httpCookieAcceptPolicy = .always
        session = URLSession(configuration: urlConfiguration,delegate: sessionDelegate, delegateQueue: nil)
        session .configuration.httpShouldSetCookies = true
        
        // Check the http method and pass the URL and Paramaters.
        
        if httpMethod == "GET" {
            
            let urlString = baseURL + parameters
            
            let encodedURLString = urlString.encodeUrl()
            requestURL = URL(string:encodedURLString)
            urlRequest = URLRequest(url:requestURL!)
            
        } else if httpMethod == "POST" || httpMethod == "DELETE" || httpMethod == "PUT" {
            requestURL = URL(string: baseURL)
            urlRequest = URLRequest(url: requestURL!)
            
            if contentType == "application/X-WWW-form-urlencoded" {
                
                urlRequest?.httpBody = parameters.data(using: .utf8)
            

        } else if contentType == "application/hal+json" || contentType == "application/json" {
       
            do {
                let dictObject = self.convertToDictionary(parameters: parameters)
                urlRequest?.httpBody = try JSONSerialization.data(withJSONObject: dictObject ?? "Empty Dictionary", options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        }
        urlRequest?.setValue(contentType, forHTTPHeaderField: "Content-Type")
        urlRequest?.httpMethod = httpMethod
        session.dataTask(with: urlRequest!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let data1 = data, let str = String.init(data: data1, encoding: String.Encoding.utf8) {
                print(str)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(nil, nil, nil, "Currently Unavailable")

                return
            }
             if httpResponse.status?.responseType == HTTPStatusCode.ResponseType.clientErrorValidations || httpResponse.status?.responseType == HTTPStatusCode.ResponseType.clientError || httpResponse.status?.responseType == HTTPStatusCode.ResponseType.success
                
                {
                guard let responseData = data else {
                    print("Error: Did not receive Data")
                    completionHandler(nil, nil, nil, "Currently Unavailable")

                    return
                }
            do {
                if httpResponse.status?.responseType == HTTPStatusCode.ResponseType.clientErrorValidations || httpResponse.status?.responseType == HTTPStatusCode.ResponseType.clientError || httpResponse.status?.responseType == HTTPStatusCode.ResponseType.serverError {
                    guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from data")
                    return
                }
                    guard let errorMessage = receivedTodo["errorMessage"] as? String else {
                        return
                    }
                    if let showPopUp = receivedTodo["showPopUp"] as? String, showPopUp == "false" {
                        completionHandler(nil, false, errorMessage, receivedTodo["errorCode"] as? String)
                    } else {
                        completionHandler(nil, true, errorMessage, receivedTodo["errorCode"] as? String)
                    }
                } else {
                    completionHandler(responseData, nil, nil, nil)
                }
            }
            catch {
                print("Error Parsing from response from POST")
            }
             } else {
                print("unhandled Error")
                completionHandler(nil, nil, "Service is Currently Unavailable", nil)

            }
            
            
            }).resume()

    }
    
  class func convertToDictionary(parameters: String) -> [String: Any]? {
       if let data = parameters.data(using: .utf8) {
           do {
               return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
           } catch {
               print(error.localizedDescription)
           }
       }
    return nil
   }

    
}

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}

class SessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
 
    static let instance = SessionDelegate()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Swift.Void ) {
        
        completionHandler (request)
    }
}

   
