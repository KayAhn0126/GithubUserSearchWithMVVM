//
//  DetailViewController.swift
//  GithubUserSearchWithMVVM
//
//

import UIKit
import Combine
import Kingfisher

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    var detailSubscription = Set<AnyCancellable>()
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var firstDateLabel: UILabel!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel()
        setupUI()
        bind()
    }
    
    private func bind() {
        viewModel.userInfo
            .receive(on: RunLoop.main)
            .sink { [unowned self] user in
                self.nameLabel.text = self.viewModel.nameLabel
                self.loginLabel.text = self.viewModel.loginLabel
                self.followerLabel.text = self.viewModel.followerLabel
                self.followingLabel.text = self.viewModel.followingLabel
                self.firstDateLabel.text = self.viewModel.firstDateLabel
                self.latestUpdateLabel.text = self.viewModel.latestUpdateLabel
                self.companyLabel.text = self.viewModel.companyLabel
                self.locationLabel.text = self.viewModel.locationLabel
                self.thumbnail.kf.setImage(with: self.viewModel.avatarUrl)
            }
            .store(in: &detailSubscription)
    }
    
    private func setupUI() {
        thumbnail.layer.cornerRadius = 80
    }
}
