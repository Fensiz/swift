import UIKit
import RecastAI

class ViewController: UIViewController {
	
	private lazy var label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
		label.layer.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
		label.layer.cornerRadius = 10
		label.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		label.layer.shadowOpacity = 0.5
		label.layer.shadowRadius = 10
		label.layer.shadowOffset = CGSize(width: 5, height: 7)
		return label
	}()
	private lazy var textField: UITextField = {
		let textField = UITextField()
		textField.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
		textField.layer.cornerRadius = 10
		textField.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		textField.layer.shadowOpacity = 0.5
		textField.layer.shadowRadius = 10
		textField.layer.shadowOffset = CGSize(width: 5, height: 7)
		textField.textColor = #colorLiteral(red: 0.8276386857, green: 1, blue: 0.3250560164, alpha: 1)
		let text = NSAttributedString(string: "Request text",
									  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3391147852, green: 0.4606652856, blue: 0.02831484005, alpha: 1)])
				
		textField.attributedPlaceholder = text
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
		textField.leftViewMode = .always
		textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
		textField.rightViewMode = .always
		return textField
	}()
	private lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle("Make a request", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
		button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		button.layer.cornerRadius = 10
		button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		button.layer.shadowOpacity = 0.5
		button.layer.shadowRadius = 10
		button.layer.shadowOffset = CGSize(width: 5, height: 7)
		button.addTarget(self, action: #selector(action), for: .touchUpInside)
		return button
	}()
	
	var bot : RecastAIClient!
	var botAnswer : String = ""
	private let token: String = "c80f802ac6dd241654df237385b351b5"

	override func viewDidLoad() {
		
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		view.addSubview(label)
		view.addSubview(textField)
		view.addSubview(button)
		configConstraints()
		bot = RecastAIClient(token : token, language: "en")
	}
	
	@objc private func action(sender: UIButton!) {
		if let label = textField.text {
			make(request: label)
		}
	}
	
	private func make(request: String) {
		bot?.textRequest(request, successHandler: successHandler(response:), failureHandle: failureHandler(_:))
	}
	
	private func successHandler(response: Response) {
		print(response)
		if let location = response.get(entity: "location") {
			print(location)
			let lat = location["lat"] as? Double ?? 0// as? String ?? ""
			let lng = location["lng"] as? Double ?? 0// as? String ?? ""
			label.text = "lat:\(lat) lng:\(lng)"
//			let myLoc = CLLocationCoordinate2D(latitude: location["lat"]! as! CLLocationDegrees, longitude: location["lng"]! as! CLLocationDegrees)
//			self.client!.getForecast(location: myLoc, completion: completion)
		} else {
			label.text = "Invalid place"
		}
//		print(response)
//		if response.intents?.count != 0 {
//			if response.intent()?.slug == "get-weather" {
//				self.botAnswer = "Intent: Weather"
//				if let ret = response.get(entity: "location") as NSDictionary? {
//					self.botAnswer = "\(self.botAnswer)\n\(ret.value(forKey: "formatted") as! String)"
//					if ret["lat"] != nil && ret["lng"] != nil {
//						self.askDarkSky(lat: ret.value(forKey: "lat") as! Double, lng: ret.value(forKey: "lng") as! Double)
//					}
//
//				}
//			} else {
//				self.lab_answer.text = "Intent: \(String(describing: Response.intent()?.slug))"
//			}
//		} else {
//			DispatchQueue.main.async {
//				self.lab_answer.text = "Error: no intent"
//			}
//		}
//		label.text = response.
	}
	
	private func failureHandler(_: Error) {
		label.text = "Request Fail"
	}
	
	private func configConstraints() {
		let width: CGFloat = 300
		let height: CGFloat = 50
		let indent: CGFloat = 50
		label.translatesAutoresizingMaskIntoConstraints = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			textField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			textField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			label.centerYAnchor.constraint(equalTo: textField.topAnchor, constant: -indent),
			button.centerYAnchor.constraint(equalTo: textField.bottomAnchor, constant: indent),
			label.widthAnchor.constraint(equalToConstant: width),
			textField.widthAnchor.constraint(equalToConstant: width),
			button.widthAnchor.constraint(equalToConstant: width),
			label.heightAnchor.constraint(equalToConstant: height),
			textField.heightAnchor.constraint(equalToConstant: height),
			button.heightAnchor.constraint(equalToConstant: height)
		])
	}
}

