import UIKit

class Shape: UIView {
	let isCircle = Bool.random()
	
	init(origin: CGPoint) {
		let size: CGFloat = 100
		super.init(frame: CGRect(origin: CGPoint(x: origin.x - size / 2, y: origin.y - size / 2),
								 size: CGSize(width: size, height: size)))
		backgroundColor = .random
		if isCircle {
			layer.cornerRadius = size / 2
			layer.masksToBounds = true
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
