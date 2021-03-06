//
//  MapViewController.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 19/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // Main View Outlets
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var informationDetailView: UIView!
    @IBOutlet weak var im: UIImageView!
    @IBOutlet weak var informationTextView: UITextView!
    // PopOver View Outlets
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet var popOverFilter: UIView!
    @IBOutlet var disableAnimationsView: UIView!
    @IBOutlet weak var popOverSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var exitInfo: UIButton!
    @IBOutlet weak var isAnimationEnabledSwitch: UISwitch!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var animationEnabledButton: UIButton!

    // Variables and constants
    var centerBtnIsCentered: Bool = false
    var didPressCenterBtn = false
    var mapIsCenteredInUser = false
    let regionInMeters: Double = 750
    let locationManager = CLLocationManager()
    let CBCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: -22.816939) ?? 0, longitude: CLLocationDegrees(exactly: -47.069752) ?? 0)
    
    
    // Control variables
    var shouldDisplayRadiusAnimation = false
    
    // AnnotationViews
    var annotationViews: [MKAnnotationView] = []
    
    // Debug
    var c: Int = 0
    
    // Test data sources for the popover filter
    
    struct LivingBeingClassAttributes {
        var nome: String
        var isOn: Bool
        var beingKingdom: LivingBeingKingdom
    }
    
    enum LivingBeingKingdom {
        case planta
        case animal
    }
    
    var livingBeingClassData = [LivingBeing.LivingBeingClass.anfibio: LivingBeingClassAttributes(nome: "Anfibio", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.ave: LivingBeingClassAttributes(nome: "Ave", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.mamifero: LivingBeingClassAttributes(nome: "Mamifero", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.reptil: LivingBeingClassAttributes(nome: "Reptil", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.peixe: LivingBeingClassAttributes(nome: "Peixe", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.inseto: LivingBeingClassAttributes(nome: "Inseto", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.briofita: LivingBeingClassAttributes(nome: "Briofitas", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.pteridofitas: LivingBeingClassAttributes(nome: "Pteridofitas", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.angiospermas: LivingBeingClassAttributes(nome: "Angiospermas", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.gimnospermas: LivingBeingClassAttributes(nome: "Gimnospermas", isOn: true, beingKingdom: .planta)]
    
    var livingBeingData: [LivingBeingAnnotation] = {
        var data: [LivingBeingAnnotation] = []
        
        for being in MVPData.sharedInstance.data {
            let annotation = LivingBeingAnnotation(name: being.name, scientificName: being.scientificName, beingClass: being.beingClass, coordinate: being.coordinate, areaRadius: being.areaRadius)
            data.append(annotation)
        }
        
        return data
    }()

    var animalClasses: [LivingBeingClassAttributes] = []
    var plantClasses: [LivingBeingClassAttributes] = []
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(LivingBeingView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        animalClasses = livingBeingClassData.map { (keyValue) -> LivingBeingClassAttributes? in
            if keyValue.value.beingKingdom == .animal {
                return keyValue.value
            } else {
                return nil
            }
        }.compactMap { $0 }
        plantClasses = livingBeingClassData.map { (keyValue) -> LivingBeingClassAttributes? in
            if keyValue.value.beingKingdom == .planta {
                return keyValue.value
            } else {
                return nil
            }
        }.compactMap { $0 }
        
        
        
        // Delegate and Datasource setup
        self.mapView.delegate = self
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        
        // Corner radius setup
        let popOverCornerRadiusValue  = CGFloat(10)
        
        self.popOverFilter.layer.cornerRadius = popOverCornerRadiusValue
        self.doneButton.layer.cornerRadius = popOverCornerRadiusValue
        self.exitInfo.layer.cornerRadius = self.exitInfo.bounds.width/2
        
        
        self.filterBtn.layer.cornerRadius = 0.5 * filterBtn.bounds.size.width
        self.centerBtn.layer.cornerRadius = 0.5 * centerBtn.bounds.size.width
        
        checkLocationServices()
        addAnnotations()
        centerBtn.addTarget(self, action: #selector(centerBtnAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotations()
    }
    
    // Outlet-related methods
    @objc func centerBtnAction() {
        if centerBtnIsCentered {
            centerBtnIsCentered = false
            centerBtn.setImage(UIImage(named: "centerOff"), for: .normal)
        }
        else {
            centerBtnIsCentered = true
            didPressCenterBtn = true
            centerBtn.setImage(UIImage(named: "centerOn"), for: .normal)
            centerViewOnUserLocation()
            
        }
    }
    @IBAction func animationSetupPressed(_ sender: UIButton) {
        guard sender.tag == 1 else { return }
        self.view.addBlurEffect()
        self.view.addSubview(disableAnimationsView)
        self.disableAnimationsView.center  = self.view.center
        self.mapView.isUserInteractionEnabled  = false
    }
    
    @IBAction func animationEnabledPressed(_ sender: UIButton) {
        guard sender.tag == 2 else { return }
        self.view.removeBlurEffect()
        self.disableAnimationsView.removeFromSuperview()
        self.mapView.isUserInteractionEnabled = true
        if !self.animationSwitch.isOn {
                   self.shouldDisplayRadiusAnimation = false
                   addAnnotations()
               } else {
                   self.shouldDisplayRadiusAnimation = true
               }
    }
    
    
    @IBAction func filterPressed(_ sender: UIButton) {
        guard sender.tag == 0 else { return }
        self.view.addBlurEffect()
        self.view.addSubview(popOverFilter)
        self.popOverFilter.center = self.view.center
        self.mapView.isUserInteractionEnabled = false
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        guard sender.tag == 3 else { return }
        self.filterTableView.reloadData()
        self.view.removeBlurEffect()
        self.popOverFilter.removeFromSuperview()
        self.mapView.isUserInteractionEnabled = true
        if !self.animationSwitch.isOn {
            self.shouldDisplayRadiusAnimation = false
        } else {
            self.shouldDisplayRadiusAnimation = true
        }
        addAnnotations()
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.filterTableView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.view.removeBlurEffect()
self.informationDetailView.removeFromSuperview()
        self.mapView.isUserInteractionEnabled = true
    }
    
    
    // Localization logic and setup methods
    private func centerViewOnCB() {
        let region = MKCoordinateRegion(center: CBCenter, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnCB()
            //centerViewOnUserLocation()
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("Unknown autorization status")
            break
        }
    }

}

// Extensions
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard centerBtnIsCentered else { return }
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center,
                                             latitudinalMeters: regionInMeters,
                                             longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if didPressCenterBtn && mapIsCenteredInUser {
            didPressCenterBtn = false
            c = 1
        }
        else {
            if didPressCenterBtn == false {
                centerBtnIsCentered = false
                centerBtn.setImage(UIImage(named: "centerOff"), for: .normal)
            }
        }
        
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            //print("\(mapView.region.center.latitude) == \(region.center.latitude)")
            if mapView.region.center.latitude <= region.center.latitude + 0.00002 && mapView.region.center.latitude >= region.center.latitude - 0.00002 || mapView.region.center.longitude <= region.center.longitude + 0.00002 && mapView.region.center.longitude >= region.center.longitude - 0.00002 {
                mapIsCenteredInUser = true
            }
        }

        if didPressCenterBtn == false && c == 1 {
                centerBtnIsCentered = false
                centerBtn.setImage(UIImage(named: "centerOff"), for: .normal)
        }
        c = 0
    }
    
    // Pin related methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? LivingBeingAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        self.removePulse(annotationView ?? UIView())
        
        if annotationView == nil {
            annotationView = LivingBeingView(annotation: annotation, reuseIdentifier: identifier)
            if let livingBeingView = annotationView as? LivingBeingView {
                livingBeingView.species = annotation.scientificName

                livingBeingView.delegate = self
            }
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
            annotationView!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        }

        if shouldDisplayRadiusAnimation {
            createPulse(annotationView: annotationView!, radius: annotation.areaRadius)
        }
        
        return annotationView
    }
    
    func addAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        annotationViews.removeAll()
        for being in livingBeingData {
            if livingBeingClassData[being.beingClass]?.isOn ?? false {
                mapView.addAnnotation(being)
            }
        }
    }
    
    func removePulse(_ view: UIView) {
        for sublayer in view.layer.sublayers  ?? [] where sublayer is CAShapeLayer {
            sublayer.removeFromSuperlayer()
        }
    }
    
    // Pin pulse animation methods
    func createPulse(annotationView: MKAnnotationView, radius: CGFloat) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/4.0 * radius * 0.01, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        let pulseLayer = CAShapeLayer()
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 4.0
        let strokeColor = UIColor(red: CGFloat(51.0/255) , green: CGFloat(197.0/255), blue: CGFloat(49.0/255), alpha: 1.0)
        pulseLayer.fillColor = strokeColor.cgColor
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.position = CGPoint(x: (annotationView.frame.size.width/2), y: (annotationView.frame.size.height/2))
        annotationView.layer.addSublayer(pulseLayer)
        
        for layer in annotationView.layer.sublayers ?? []{
            layer.anchorPointZ = -1
        }
        
        animatePulse(pulseLayer: pulseLayer)
    }
    
    func animatePulse(pulseLayer: CAShapeLayer) {
        
        // rgb(51, 178, 49)
        
        let strokeColor = UIColor(red: CGFloat(51.0/255) , green: CGFloat(197.0/255), blue: CGFloat(49.0/255), alpha: 1.0)
    
        pulseLayer.strokeColor = strokeColor.cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(opacityAnimation, forKey: "opacity")
        
    }
}


extension MapViewController: LivingBeingDelegate {
    func tapOn(species: String) {
        
        self.view.addBlurEffect()
        self.view.addSubview(informationDetailView)
        self.informationDetailView.center = self.view.center
        self.informationDetailView.layer.cornerRadius = 20
        self.mapView.isUserInteractionEnabled = false
        
        if let data = findLivingBeing(species)  {
            im.image = data.photos[0]
            im.layer.cornerRadius = im.frame.width/2
            
            var text = "<font face = \"sans-serif\" size=\"14\"><b> \(data.name) </b></font> <br>" +
                "<font face = \"sans-serif\" size=\"5\"> <i>\(data.scientificName)</i> </font> <hr>"
            text +=
                    "<font face = \"sans-serif\" size=\"6\"> <b>Localização no campus</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(data.locationOnCampus) </font> <br><br>"
            informationTextView.attributedText = text.htmlToAttributedString
            informationTextView.isEditable = false
            
        }
        
    }
    
    func findLivingBeing(_ scientificName: String) -> LivingBeing?{
        for livingBeing in MVPData.sharedInstance.data {
            if livingBeing.scientificName == scientificName{
                return livingBeing
            }
        }
        return nil
    }
    
}

extension MapViewController: UITableViewDelegate {
    // If necessary, add UITableViewDelegate methods here
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0 // Default value
    
        switch self.popOverSegmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = animalClasses.count
        case 1:
            returnValue = plantClasses.count
        default:
            print("Unkown index")
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.filterTableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        
        myCell.cellCoordinates = (indexPath.row, popOverSegmentedControl.selectedSegmentIndex)
        myCell.delegate = self
        
        switch popOverSegmentedControl.selectedSegmentIndex {
        case 0:
            myCell.filterCellLabel.text = self.animalClasses[indexPath.row].nome
            myCell.filterCellSwitch.isOn = self.animalClasses[indexPath.row].isOn
        case 1:
            myCell.filterCellLabel.text = self.plantClasses[indexPath.row].nome
            myCell.filterCellSwitch.isOn = self.plantClasses[indexPath.row].isOn
        default:
            print("Unkown index")
        }
        return myCell
    }
}

extension UIView {
    
    func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    // Remove UIBlurEffect from UIView
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}

extension MapViewController: FilterDelegate {
    
    func filter(selectedCell: (row: Int, page: Int), setTo value: Bool) {
        switch selectedCell.page {
        case 0:
            self.animalClasses[selectedCell.row].isOn = value
            for key in self.livingBeingClassData.keys {
                if livingBeingClassData[key]?.nome == animalClasses[selectedCell.row].nome {
                    livingBeingClassData[key]?.isOn = value
                }
            }
        case 1:
            self.plantClasses[selectedCell.row].isOn = value
            for key in self.livingBeingClassData.keys {
                if livingBeingClassData[key]?.nome == animalClasses[selectedCell.row].nome {
                    livingBeingClassData[key]?.isOn = value
                }
            }
        default:
            print("Unknown")
        }
    }
}

class LivingBeingAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var name: String
    var scientificName: String
    var beingClass: LivingBeing.LivingBeingClass
    var coordinate: CLLocationCoordinate2D
    var areaRadius: CGFloat
    var imageName: String? {
        switch beingClass {
        case .anfibio:
            return "iconAnfibio"
        case .angiospermas:
            return "iconAngiosperma"
        case .ave:
            return "iconAve"
        case .briofita:
            return "iconBriofita"
        case .gimnospermas:
            return "iconGimnosperma"
        case .inseto:
            return "iconInseto"
        case .mamifero:
            return "iconMamifero"
        case .peixe:
            return "iconPeixe"
        case .pteridofitas:
            return "iconPteridofitas"
        case .reptil:
            return "iconReptil"
        }
    }
    init(name: String, scientificName: String, beingClass: LivingBeing.LivingBeingClass, coordinate: (latitude: Double, longitude: Double), areaRadius: CGFloat) {
        self.name = name
        self.scientificName = scientificName
        self.beingClass = beingClass
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: coordinate.latitude) ?? 0, longitude: CLLocationDegrees(exactly: coordinate.longitude) ?? 0)
        self.areaRadius = areaRadius
        self.title = name
        
        super.init()
    }
}

protocol LivingBeingDelegate: class {
    func tapOn(species: String)
}


class LivingBeingView: MKAnnotationView {
    private var imageView: UIImageView!
    var species: String = ""
    weak var delegate: LivingBeingDelegate?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let being = newValue as? LivingBeingAnnotation else {return}
            
            self.species = being.scientificName
            
           let btn = UIButton(type: .detailDisclosure)
            btn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            rightCalloutAccessoryView = btn
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = being.scientificName
            detailCalloutAccessoryView = detailLabel
            
            if let imageName = being.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.addSubview(self.imageView)
        
        //self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.tapOn(species: species)
    }
}
