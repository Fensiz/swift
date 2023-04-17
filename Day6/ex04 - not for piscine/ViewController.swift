import UIKit
import CoreMotion

class ViewController: UIViewController {
	private var animator: UIDynamicAnimator!
	private var gravity: UIGravityBehavior!
	private var collision: UICollisionBehavior!
	private var itemBehavior: UIDynamicItemBehavior!
	private var manager: CMMotionManager!
	private var snapBehavior: UISnapBehavior!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		confTapGesture()
		confAnimator()
		confMotion()
	}
	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("began")
		if let touch = touches.first, touches.count == 1 {
			let touchLocation = touch.location(in: self.view)
			for shape in view.subviews {
				if (shape.frame.contains( touchLocation )) {
					print("beganIn")
					snapBehavior = UISnapBehavior(item: shape, snapTo: touchLocation)
					snapBehavior?.damping = 0.5
					animator?.addBehavior(snapBehavior!)
				}
			}
		}
	}

	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first, touches.count == 1 {
			let touchLocation = touch.location( in: self.view )
			if let snapBehavior = snapBehavior {
				snapBehavior.snapPoint = touchLocation
			}
		}
	}

	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("end")
		if let snapBehavior = snapBehavior {
			print("endIn")
			animator?.removeBehavior(snapBehavior)
		}
		snapBehavior = nil
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

//MARK: - Motion configuration
private extension ViewController {
	func confMotion() {
		manager = CMMotionManager()
		if (manager.isDeviceMotionAvailable) {
			manager.deviceMotionUpdateInterval = 0.02
			manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: handleMotion)
		}
	}
	func handleMotion(motion:CMDeviceMotion?, error:Error?) {
		if let data = motion {
			gravity.gravityDirection = CGVector(dx: data.gravity.x, dy: -data.gravity.y)
		}
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
		let touchLocation = sender.location(in: view)
		for shp in view.subviews {
			if (shp.frame.contains( touchLocation )) {
				if let snapBehavior = snapBehavior {
					print("endIn")
					animator?.removeBehavior(snapBehavior)
				}
				snapBehavior = nil
				return
			}
		}
		view.addSubview(shape)
		collision.addItem(shape)
		gravity.addItem(shape)
		
		let rotation = UIRotationGestureRecognizer(target: self,
												   action: #selector(self.handleRotate(sender:)))
		shape.addGestureRecognizer(rotation)
//		let pan = UIPanGestureRecognizer(target: self,
//										 action: #selector(self.handlePan(sender:)))
//		shape.addGestureRecognizer(pan)
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
			if let snapBehavior = snapBehavior {
				print("endIn")
				animator?.removeBehavior(snapBehavior)
				self.snapBehavior = nil
			}
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
			collision.removeItem(element)
			let center = element.center
			let size = element.bounds.size.width * sender.scale
			let origin = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
			element.bounds.origin = origin
			element.bounds.size = CGSize(width: size, height: size)
			if element.layer.cornerRadius != 0 {
				element.layer.cornerRadius = size / 2
			}
			sender.scale = 1
			print("change")
			
			collision.addItem(element)
		case .ended:
			gravity.addItem(element)
			if let snapBehavior = snapBehavior {
				print("endIn")
				animator?.removeBehavior(snapBehavior)
				self.snapBehavior = nil
			}
			
		default:
			break
		}
	}
}
