import UIKit
import MapKit

class MapViewController: UIViewController {
	
	private var mapView: MKMapView!
	
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

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configMapView()
	}
}
