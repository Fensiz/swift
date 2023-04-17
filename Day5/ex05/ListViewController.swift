import UIKit

protocol ControllerPusherDelegate {
	func push()
}

class ListViewController: UIViewController, ControllerPusherDelegate, SetAnnotationDelegate {
	func setAnnotation(locs: [Location]) {
		cells = locs
	}
	
	private var cells: [Location]!
	private var tableView: UITableView? = nil
	
	private func configTableView() {
		tableView = UITableView()
		view.addSubview(tableView!)
		tableView?.dataSource = self
		tableView!.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		tableView!.register(MyCell.self, forCellReuseIdentifier: "cell")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		cells = (tabBarController as! TabBarController).cells
		view.backgroundColor = .white
		configTableView()
	}
	
	func push() {
		let tabBarController = (self.tabBarController) as! TabBarController
		tabBarController.selectedViewController = tabBarController.mapController
	}
}

extension ListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
		var conf = cell.defaultContentConfiguration()
		conf.text = cells[indexPath.row].name
		cell.contentConfiguration = conf
		cell.loc = cells[indexPath.row]
		cell.setterDelegate = ((self.tabBarController) as! TabBarController).mapController
		cell.pusher = self
		return cell
	}
}
