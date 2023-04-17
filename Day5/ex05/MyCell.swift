import UIKit


class MyCell: UITableViewCell {
	var pusher: ControllerPusherDelegate? = nil
	var setterDelegate: SetAnnotationDelegate? = nil
	var loc: Location!
	
	private var startTouchPoint: CGPoint!
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		startTouchPoint = frame.origin
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if startTouchPoint == frame.origin {
			setterDelegate?.setAnnotation(locs: [loc])
			pusher?.push()
		}
	}
}
