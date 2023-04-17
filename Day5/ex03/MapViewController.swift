import UIKit
import MapKit

class MapViewController: UIViewController {
	
	private var mapView: MKMapView!
	private var segment: UISegmentedControl!
	
	private func configMapView() {
		let annotation = MKPointAnnotation()
		annotation.title = "42"
		annotation.subtitle = "Ecole 42"
		annotation.coordinate = CLLocationCoordinate2D(latitude: 48.89662, longitude: 2.31851)

		mapView = MKMapView()
		view.addSubview(mapView)
		mapView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
		mapView.showAnnotations([annotation], animated: true)
	}
	
	private func configSegmentedControl() {
		segment = UISegmentedControl(items: ["Standart", "Satelite", "Hybrid"])
		segment.selectedSegmentIndex = 0
		segment.backgroundColor = .gray
		segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

		view.addSubview(segment)
		segment.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			segment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
			segment.heightAnchor.constraint(equalToConstant: 30),
			segment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
			segment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configMapView()
		configSegmentedControl()
	}
	
	@objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch (sender.selectedSegmentIndex) {
		case 0:
			mapView.mapType = .standard
		case 1:
			mapView.mapType = .satellite
		default:
			mapView.mapType = .hybrid
		}
	}
}
