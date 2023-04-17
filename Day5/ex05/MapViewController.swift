import UIKit
import MapKit
import CoreLocation

protocol SetAnnotationDelegate {
	func setAnnotation(locs: [Location])
}

class MapViewController: UIViewController, CLLocationManagerDelegate {

	private var annotations: [MKPointAnnotation]! {
		didSet {
			if mapView != nil && annotations != nil {
				mapView.showAnnotations(annotations, animated: true)
				
				if annotations.count != 1 {
					mapView.fitAll()
				}
				print("annotation count: \(annotations.count)")
				annotations.forEach({print($0.coordinate)})
			}
		}
	}
	private var mapView: MKMapView!
	private var segment: UISegmentedControl!
	let locationManager = CLLocationManager()
	
	
	// вызывается при выборе MapViewController.tabItem и первичной загрузке MapViewController
	func loadAnnotations() {
		annotations = [MKPointAnnotation]()
		let locs = (tabBarController as! TabBarController).cells
		for loc in locs {
			let annotation = MKPointAnnotation()
			annotation.title = loc.name
			annotation.subtitle = loc.description
			if let found = loc.location {
				print("location exist: \(String(describing: annotation.title))")
				annotation.coordinate = found
				self.annotations.append(annotation)
			} else {
				forwardGeocoding(address: loc.name)
				print("location found")
			}
		}
	}
	
	private func configMapView() {
		loadAnnotations()
		mapView = MKMapView()
		view.addSubview(mapView)
		mapView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
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
		if let location = locationManager.location {
			let center = location.coordinate
			let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
			self.mapView.setRegion(region, animated: true)
		} else {
			print("No location")
		}
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
	
	//функция добавляет аннотацию для локации по имени
	func forwardGeocoding(address: String) {
		print("start of ForwardGeo")
		var location: CLLocation!
		let annotation = MKPointAnnotation()
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in //async
			if error != nil {
				print("Failed to retrieve location")
				return
			}
			if let placemarks = placemarks, placemarks.count > 0 {
				location = placemarks.first?.location
				annotation.coordinate = location.coordinate
				annotation.title = placemarks.first?.name
				annotation.subtitle = placemarks.first?.country
				self.annotations.append(annotation)
			} else {
				print("No Matching Location Found")
			}
		})
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			 // start updating location here
			print("StartUpdating")
			locationManager.startUpdatingLocation()
		}
	}
	
	// Получаем координаты
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let coordinates = locations.last?.coordinate else {
			return
		}
		// Смотрим на координаты
		print(coordinates)
	}
	// Обрабатываете ошибки
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}

extension MapViewController: SetAnnotationDelegate {
	// устанавливает Location при касанию по ячейке
	func setAnnotation(locs: [Location]) {
		self.mapView.removeAnnotations(annotations)
		self.annotations.removeAll()
//		self.annotations = [MKPointAnnotation]()
		for loc in locs {
			let annotation = MKPointAnnotation()
			annotation.title = loc.name
			annotation.subtitle = loc.description
			if let found = loc.location {
				print("location exist: \(String(describing: annotation.title))")
				annotation.coordinate = found
				self.annotations.append(annotation)
			} else {
				forwardGeocoding(address: loc.name)
				print("location found")
			}
		}
	}
}
