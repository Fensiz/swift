import UIKit

enum Tabs: Int {
	case map
	case list
	case more
}

class TabBarController : UITabBarController {
	
	var cells: [Location] = Location.demo()

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var mapController: MapViewController!
	var moreController: MoreViewController!
	var listController: ListViewController!
	
	private func configure() {
		tabBar.tintColor = .orange
		tabBar.barTintColor = .red
		tabBar.backgroundColor = .white
		
		tabBar.layer.borderColor = UIColor.gray.cgColor
		tabBar.layer.borderWidth = 1
		tabBar.layer.masksToBounds = true
		
		mapController = MapViewController()
		listController = ListViewController()
		moreController = MoreViewController()
		let listNavController = UINavigationController(rootViewController: listController)
		mapController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.map,
												image: Resources.Images.TabBar.map,
												tag: Tabs.map.rawValue)
		listNavController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.list,
													image: Resources.Images.TabBar.list,
													tag: Tabs.list.rawValue)
		moreController.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.more,
												 image: Resources.Images.TabBar.more,
												 tag: Tabs.more.rawValue)
		setViewControllers([mapController, listNavController, moreController], animated: true)
	}
}

extension TabBarController: UITabBarControllerDelegate {
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		if item == mapController.tabBarItem {
			mapController.loadAnnotations()
		}
	}
}
