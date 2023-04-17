import UIKit
import MapKit
import CoreLocation

protocol SetAnnotationDelegate {
	func setAnnotation(loc: Location)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {

	private var annotation: MKPointAnnotation!
	private var mapView: MKMapView!
	private var segment: UISegmentedControl!
	let locationManager = CLLocationManager()
	
	
	private func configMapView() {
		annotation = MKPointAnnotation()
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
		mapView.showsUserLocation = true
		mapView.isZoomEnabled = true
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
	
	private func configPositionButton() {
		let view = UIView()
		/* добавление action по касанию */
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		view.addGestureRecognizer(tapGesture)
		
		self.view.addSubview(view)
		view.backgroundColor = .white
		view.layer.cornerRadius = 30
		view.layer.borderColor = UIColor.gray.cgColor
		view.layer.borderWidth = 2
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: 60),
			view.heightAnchor.constraint(equalToConstant: 60),
			view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
			view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "location")
		view.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 11),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -9),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11)
		])
	}
	
	@objc func handleTap(sender: UITapGestureRecognizer) {
		print("tap")
		let center = locationManager.location!.coordinate
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		self.mapView.setRegion(region, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		print("didLoad")
		view.backgroundColor = .white
		configMapView()
		configSegmentedControl()
		configPositionButton()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
	}
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			 // start updating location here
			locationManager.startUpdatingLocation()
		}
	}
	
	// Получаем координаты
	func locationManager(_ manager: CLLocationManager,
						 didUpdateLocations locations: [CLLocation]) {
		guard let coordinates = locations.last?.coordinate else {
			return
		}
		// Смотрим на координаты
		print(coordinates)
	}
	// Обрабатываете ошибки
	func locationManager(_ manager: CLLocationManager,
						 didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("willAppear")
		mapView.showAnnotations([annotation], animated: true)
	}
}

extension MapViewController: SetAnnotationDelegate {
	func setAnnotation(loc: Location) {
		if let location = loc.location {
			let annotation = MKPointAnnotation()
			annotation.title = loc.name
			annotation.subtitle = loc.description
			annotation.coordinate = location
			self.annotation = annotation
		}
	}
}
