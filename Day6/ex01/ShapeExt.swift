import UIKit

extension Shape {
	override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
		if isCircle {
			return .ellipse
		} else {
			return .rectangle
		}
	}
}
