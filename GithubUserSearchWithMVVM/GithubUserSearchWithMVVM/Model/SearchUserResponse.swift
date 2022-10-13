//
//  SearchUserResponse.swift
//  GithubUserSearchWithMVVM
//
//

import Foundation

struct SearchUserResponse: Decodable {
    var items: [SearchResult]
}
