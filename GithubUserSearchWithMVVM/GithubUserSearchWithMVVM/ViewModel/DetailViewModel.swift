//
//  DetailViewModel.swift
//  GithubUserSearchWithMVVM
//
//  Created by Kay on 2022/10/13.
//

import Foundation
import Combine

final class DetailViewModel {
    var userInfo: CurrentValueSubject<DetailSearchResult?, Never>
    
    var nameLabel: String {
        guard let name = userInfo.value?.name else { return "Name : Secret!"
        }
        return "Name : \(name)"
    }
    
    var loginLabel: String {
        guard let login = userInfo.value?.login else { return "Github id : Can't find!"
        }
        return "Github id : " + login
    }
    
    var followerLabel: String {
        guard let follower = userInfo.value?.followers else { return "followers : undefined"
        }
        return "followers : \(follower)"
    }
    
    var followingLabel: String {
        guard let following = userInfo.value?.following else { return "following : undefined"
        }
        return "following : \(following)"
    }
    
    var firstDateLabel: String {
        guard let firstDate = userInfo.value?.firstDate else { return "first date : undefined"
        }
        return "first date : \(firstDate)"
    }
    
    var latestUpdateLabel: String {
        guard let latestupdateDate = userInfo.value?.latestupdateDate else { return "latest update : undefined"
        }
        return "latest update : \(latestupdateDate)"
    }
    
    var companyLabel: String {
        guard let company = userInfo.value?.company else { return "company : undefined"
        }
        return "company : \(company)"
    }
    
    var locationLabel: String {
        guard let location = userInfo.value?.location else { return "location : undefined"
        }
        return "location : \(location)"
    }
    
    var avatarUrl: URL? {
        guard let url = userInfo.value?.avatarUrl else { return nil }
        return url
    }
    
    init(userInfo: DetailSearchResult? = nil) {
        self.userInfo = CurrentValueSubject(userInfo)
    }
}
