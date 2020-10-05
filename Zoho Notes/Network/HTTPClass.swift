//
//  HTTPClass.swift


import Foundation
/// This is a list of Hypertext Transfer Protocol (HTTP) response status codes.
/// It includes codes from IETF internet standards, other IETF RFCs, other specifications, and some additional commonly used codes.
/// The first digit of the status code specifies one of five classes of response; an HTTP client must recognise these five classes at a minimum.
enum HTTPStatusCode: Int, Error {
    
    /// The response class representation of status codes, these get grouped by their first digit.
    enum ResponseType {
        
        /// - success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
        case success
        
        /// - clientError: This class of status code is intended for situations in which the client seems to have erred.
        case clientError
        
        /// serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
        case clientErrorValidations
        
        /// - serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
        case serverError
        
        /// - undefined: The class of the status code cannot be resolved.
        case undefined
    }
    
    
    /// - ok: Standard response for successful HTTP requests.
    case ok = 200

    case notAcceptable = 406
    
    /// - unprocessableEntity: The request was well-formed but was unable to be followed due to semantic errors.
    case unprocessableEntity = 422
    
   
    /// - internalServerError: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.
    case internalServerError = 500

    
    /// The class (or group) which the status code belongs to.
    var responseType: ResponseType {
        
        switch self.rawValue {
            
        case 200:
            return .success
            
        case 406:
            return .clientErrorValidations
            
        case 422:
            return .clientError
            
        case 500:
            return .serverError
     
        default:
            return .undefined
            
        }
        
    }
    
}

extension HTTPURLResponse {
    
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
    
}
