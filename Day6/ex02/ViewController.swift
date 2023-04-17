import UIKit

class ViewController: UIViewController {
	var animator: UIDynamicAnimator!
	var gravity: UIGravityBehavior!
	var collision: UICollisionBehavior!
	var itemBehavior: UIDynamicItemBehavior!

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
		
		let rotation = UIRotationGestureRecognizer(target: self,
												   action: #selector(self.handleRotate(sender:)))
		shape.addGestureRecognizer(rotation)
		let pan = UIPanGestureRecognizer(target: self,
										 action: #selector(self.handlePan(sender:)))
		shape.addGestureRecognizer(pan)
		let pinch = UIPinchGestureRecognizer(target: self,
											 action: #selector(self.handlePinch(sender:)))
		shape.addGestureRecognizer(pinch)
	}
	@objc func handleRotate(sender: UIRotationGestureRecognizer) {
		guard let element = sender.view else {
			print("Error: rotation gesture")
			return
		}
		switch sender.state {
			case .began:
				gravity.removeItem(element)
			case .changed:
				element.transform = CGAffineTransform(rotationAngle: sender.rotation)
				animator.updateItem(usingCurrentState: element)
			case .ended:
				gravity.addItem(element)
			default:
				break
		}
		
	}
	@objc func handlePan(sender: UIPanGestureRecognizer) {
		guard let element = sender.view else {
			print("Error: pan gesture")
			return
		}
		switch sender.state {
			case .began:
				gravity.removeItem(element)
			case .changed:
				element.center = sender.location(in: self.view)
				animator.updateItem(usingCurrentState: element)
			case .ended:
				gravity.addItem(element)
			default:
				break
		}
	}
	@objc func handlePinch(sender: UIPinchGestureRecognizer) {
		guard let element = sender.view else {
			print("Error: pinch gesture")
			return
		}
		switch sender.state {
		case .began:
			gravity.removeItem(element)
		case .changed:
			
			let center = element.center
			let size = element.bounds.size.width * sender.scale
			let origin = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
			element.bounds.origin = origin
			element.bounds.size = CGSize(width: size, height: size)
			if element.layer.cornerRadius != 0 {
				element.layer.cornerRadius = size / 2
			}
			sender.scale = 1
			collision.removeItem(element)
			collision.addItem(element)
		case .ended:
			gravity.addItem(element)
		default:
			break
		}
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
