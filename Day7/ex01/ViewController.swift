import UIKit

class ViewController: UIViewController {
	
	private var label: UILabel = {
		let label = UILabel()
		label.layer.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
		label.layer.cornerRadius = 10
		label.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		label.layer.shadowOpacity = 0.5
		label.layer.shadowRadius = 10
		label.layer.shadowOffset = CGSize(width: 5, height: 7)
		return label
	}()
	private var textField: UITextField = {
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
	private var button: UIButton = {
		let button = UIButton()
		button.setTitle("Make a request", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
		button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		button.layer.cornerRadius = 10
		button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		button.layer.shadowOpacity = 0.5
		button.layer.shadowRadius = 10
		button.layer.shadowOffset = CGSize(width: 5, height: 7)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		view.addSubview(label)
		view.addSubview(textField)
		view.addSubview(button)
		configConstraints()
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

