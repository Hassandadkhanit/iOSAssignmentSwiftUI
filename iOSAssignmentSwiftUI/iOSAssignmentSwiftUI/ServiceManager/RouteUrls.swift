//
//  RouteUrls.swift
//  GitHubProfile
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation

struct RouteUrls {
    
    static let lessons               = "/test-api/lessons"
    
    static func getRouteUrlWith(route: String) -> String  {
        let baseUrl = Constants.baseUrl
        return baseUrl + route
    }
}
