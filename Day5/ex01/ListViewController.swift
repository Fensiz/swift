import UIKit

class ListViewController: UIViewController {
	
	private var cells = ["42","Saint Ouen", "Grenoble", "Reims", "Moldavie", "Circuit"]
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
		tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configTableView()
	}
}

extension ListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		var conf = cell.defaultContentConfiguration()
		conf.text = cells[indexPath.row]
		cell.contentConfiguration = conf
		return cell
	}
}

