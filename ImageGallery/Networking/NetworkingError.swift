//
//  NetworkingError.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import Foundation


enum NetworkingError : Error {
    case emptyResponse
    case wrongResponse
}


extension NetworkingError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Empty response"
        case .wrongResponse:
            return "wrong response format"
        }
    }
}
