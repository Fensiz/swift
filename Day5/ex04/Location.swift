import MapKit

struct Location {
	let name: String
	let description: String
	let location: CLLocationCoordinate2D?
	init(name: String, description: String, location: CLLocationCoordinate2D? = nil) {
		self.name = name
		self.description = description
		self.location = location
	}
	
	static func demo() -> [Location] {
		var loc = [Location]()
		loc.append(Location(name: "42",
							description: "Ecole 42",
							location: CLLocationCoordinate2D(latitude: 48.89662, longitude: 2.31851)))
		loc.append(Location(name: "Берлин",
							description: "Описание..."))
		loc.append(Location(name: "School 21",
							description: "Programming School",
							location: CLLocationCoordinate2D(latitude: 55.797138, longitude: 37.579828)))
		loc.append(Location(name: "Мадрид",
							description: "Город"))

		return loc
	}
}
