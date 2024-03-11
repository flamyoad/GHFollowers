//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by flamyoad on 24/02/2024.
//

import UIKit

typealias GfUserInfoHeaderDependencies = HasImageCache

class GFUserInfoHeaderVC: UIViewController {

    private let imageManager: ImageManager = ServiceLocator.shared.getImageManager()

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryTitleLabel(size: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSecondaryTitleLabel(size: 18)
    let bioLabel = GFBodyLabel(textAlignment: .left)
    
    var user: User!
        
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayoutConstraints()
        initUI()
    }
    
    func initUI() {
        downloadAvatarImage()
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? "Username not set"
        locationLabel.text = user.location ?? "No Location"
        bioLabel.text = user.bio ?? "No bio available"
        bioLabel.numberOfLines = 3
        
        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
    }
    
    func downloadAvatarImage() {
        Task {
            let image = await imageManager.downloadImage(from: user.avatarUrl) ?? Images.placeholder
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    func addSubviews() {
        view.addSubviews(
            avatarImageView,
            usernameLabel,
            nameLabel,
            locationImageView,
            locationLabel,
            bioLabel
        )
    }
    
    func setupLayoutConstraints() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }

}
