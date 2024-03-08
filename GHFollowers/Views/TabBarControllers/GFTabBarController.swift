//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by flamyoad on 02/03/2024.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Otherwise the uiviewcontroller overlaps the tabbar
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [
            createSearchNC(),
            createFavouritesNC()
        ]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavouritesNC() -> UINavigationController {
        let favouritesListVC = FavouriteListVC()
        favouritesListVC.title = "Favourites"
        favouritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favouritesListVC)
    }

}
