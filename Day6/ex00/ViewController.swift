import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		confTapGesture()
	}
}

//MARK: - Gesture recognizer
private extension ViewController {
	func confTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender: )))
		view.addGestureRecognizer(tap)
	}
	@objc private func handleTap(sender: UITapGestureRecognizer) {
		let shape = Shape(origin: sender.location(in: view))
		view.addSubview(shape)
	}
}
