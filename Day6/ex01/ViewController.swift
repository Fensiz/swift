import UIKit

class ViewController: UIViewController {
	private var animator: UIDynamicAnimator!
	private var gravity: UIGravityBehavior!
	private var collision: UICollisionBehavior!
	private var itemBehavior: UIDynamicItemBehavior!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		confTapGesture()
		confAnimator()
	}
}

//MARK: - Gesture recognizer
private extension ViewController {
	func confTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender: )))
		view.addGestureRecognizer(tap)
	}
	@objc func handleTap(sender: UITapGestureRecognizer) {
		let shape = Shape(origin: sender.location(in: view))
		view.addSubview(shape)
		collision.addItem(shape)
		gravity.addItem(shape)
	}
}

//MARK: - Animator configuration
private extension ViewController {
	func confAnimator() {
		animator = UIDynamicAnimator(referenceView: view)
		confGravity()
		confCollision()
		confDynamicItem()
		animator.addBehavior(gravity)
		animator.addBehavior(collision)
		animator.addBehavior(itemBehavior)
	}
	func confGravity() {
		gravity = UIGravityBehavior()
	}
	func confDynamicItem() {
		itemBehavior = UIDynamicItemBehavior()
		itemBehavior.elasticity = 0.5
	}
	func confCollision() {
		collision = UICollisionBehavior()
		collision.translatesReferenceBoundsIntoBoundary = true
	}
}

