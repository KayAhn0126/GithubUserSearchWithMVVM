//
//  SearchViewModel.swift
//  GithubUserSearchWithMVVM
//
//  Created by Kay on 2022/10/13.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel {
    
    // Date -> Output
    var searchUserResult: CurrentValueSubject<[SearchResult], Never>
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(_ searchUserResult: [SearchResult] = []) {
        self.searchUserResult = CurrentValueSubject(searchUserResult)
    }
    
    
    
    // User Action -> Input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        let base = "https://api.github.com/"
        let path = "search/users"
        let params: [String: String] = ["q": keyword]
        let header: [String: String] = ["Content-Type": "application/json"]
        
        var urlComponents = URLComponents(string: base + path)!
        let queryItems = params.map { (key: String, value: String) in
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        header.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: SearchUserResponse.self, decoder: JSONDecoder())
            .map { $0.items }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.self.searchUserResult.value, on: self)
            .store(in: &subscriptions)
    }
    
    func selectedItemToDetail(_ indexPath: IndexPath, using view: UIViewController) {
        let selectedUserName = self.searchUserResult.value[indexPath.item].login
        
        let resource = Resource<DetailSearchResult>(
            base: "https://api.github.com/",
            path: "users/\(selectedUserName)",
            params: [:],
            header: ["Content-Type": "application/json"]
        )
        let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let currentVC = detailStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let detailNetwork = NetworkService(configuration: .default)
        detailNetwork.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error Code : \(error)")
                case .finished:
                    print("Completed with: \(completion)")
                    break
                }
            } receiveValue: { result in
                currentVC.userInfo = result
            }
            .store(in: &subscriptions)
        
        view.navigationController?.navigationBar.prefersLargeTitles = false
        currentVC.navigationItem.title = selectedUserName
        view.navigationController?.pushViewController(currentVC, animated: true)
    }
}
