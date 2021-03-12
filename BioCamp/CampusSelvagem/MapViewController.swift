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
    @IBOutlet weak var settingsBtn: UIButton!
    
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
    @IBOutlet weak var enableAnimationLabel: UILabel!
    
    // Variables and constants
    var centerBtnIsCentered: Bool = false
    var didPressCenterBtn = false
    var mapIsCenteredInUser = false
    let regionInMeters: Double = 750
    let locationManager = CLLocationManager()
    let CBCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: -22.816939) ?? 0, longitude: CLLocationDegrees(exactly: -47.069752) ?? 0)
    
    
    // Control variables
    var shouldDisplayRadiusAnimation = true
    
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
    
    var livingBeingClassData = [LivingBeing.LivingBeingClass.amphibian: LivingBeingClassAttributes(nome: "Amphibian", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.bird: LivingBeingClassAttributes(nome: "Bird", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.mammmal: LivingBeingClassAttributes(nome: "Mammal", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.reptile: LivingBeingClassAttributes(nome: "Reptile", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.fish: LivingBeingClassAttributes(nome: "Fish", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.insect: LivingBeingClassAttributes(nome: "Insect", isOn: true, beingKingdom: .animal),
                                LivingBeing.LivingBeingClass.briophyte: LivingBeingClassAttributes(nome: "Briophytes", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.pteridophytes: LivingBeingClassAttributes(nome: "Pteridophytes", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.angiosperms: LivingBeingClassAttributes(nome: "Angiosperms", isOn: true, beingKingdom: .planta),
                                LivingBeing.LivingBeingClass.gimnosperms: LivingBeingClassAttributes(nome: "Gimnosperms", isOn: true, beingKingdom: .planta)]
    
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
    
    // MARK: - Lifecycle methods
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
        self.disableAnimationsView.layer.cornerRadius = popOverCornerRadiusValue
        self.animationEnabledButton.layer.cornerRadius = popOverCornerRadiusValue
        
        self.filterBtn.backgroundColor = .clear
        self.centerBtn.backgroundColor = .clear
        self.settingsBtn.backgroundColor = .clear
        
        checkLocationServices()
        addAnnotations()
        centerBtn.addTarget(self, action: #selector(centerBtnAction), for: .touchUpInside)
        
        popOverSegmentedControl.setTitle(NSLocalizedString("Animals", comment: ""), forSegmentAt: 0)
        popOverSegmentedControl.setTitle(NSLocalizedString("Plants", comment: ""), forSegmentAt: 1)
        
        doneButton.titleLabel?.text = NSLocalizedString("Done", comment: "")
        
        enableAnimationLabel.text = NSLocalizedString("Enable animations", comment: "")
        
        self.tabBarController?.tabBarItem.title = NSLocalizedString("Map", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        addAnnotations()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")

            // re-centralize the popover
            if self.view.subviews.contains(disableAnimationsView) {
                self.disableAnimationsView.center = CGPoint(x: self.disableAnimationsView.center.y,
                                                            y: self.disableAnimationsView.center.x)
            } else if self.view.subviews.contains(popOverFilter) {
                self.popOverFilter.frame.size.height = self.view.frame.height / 3.5
                self.popOverFilter.frame.size.width = self.view.frame.width
                self.popOverFilter.center = CGPoint(x: self.view.center.y,
                                                    y: self.view.center.x - (self.tabBarController?.tabBar.frame.height ?? 49)/2)
            }
        } else {
            print("Portrait")
            
            // re-centralize the popover
            if self.view.subviews.contains(disableAnimationsView){
                self.disableAnimationsView.center = CGPoint(x: self.disableAnimationsView.center.y,
                                                            y: self.disableAnimationsView.center.x)
            } else if self.view.subviews.contains(popOverFilter) {
                self.popOverFilter.frame.size.height = self.view.frame.height
                self.popOverFilter.frame.size.width = self.view.frame.width / 3.5
                self.popOverFilter.center = CGPoint(x: self.view.center.y,
                                                    y: self.view.center.x)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func animationSetupPressed(_ sender: UIButton) {
        self.view.addBlurEffect()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isTranslucent = true
        self.view.addSubview(disableAnimationsView)
        self.disableAnimationsView.center  = self.view.center
    }
    
    @IBAction func animationEnabledPressed(_ sender: UIButton) {
        self.view.removeBlurEffect()
        self.disableAnimationsView.removeFromSuperview()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.mapView.isUserInteractionEnabled = true
        if self.animationSwitch.isOn {
                   self.shouldDisplayRadiusAnimation = true
                   addAnnotations()
               } else {
                   self.shouldDisplayRadiusAnimation = false
               }
        addAnnotations()
    }
    
    
    @IBAction func filterPressed(_ sender: UIButton) {
        self.view.addBlurEffect()
        self.mapView.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isTranslucent = true
        self.view.addSubview(popOverFilter)
        self.popOverFilter.center = self.view.center
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        self.view.removeBlurEffect()
        self.filterTableView.reloadData()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.popOverFilter.removeFromSuperview()
        self.mapView.isUserInteractionEnabled = true
        if self.animationSwitch.isOn {
            self.shouldDisplayRadiusAnimation = true
        } else {
            self.shouldDisplayRadiusAnimation = false
        }
        addAnnotations()
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.filterTableView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.view.removeBlurEffect()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.mapView.isUserInteractionEnabled = true
        self.informationDetailView.removeFromSuperview()
    }
    
        // Outlet-related methods
        @objc func centerBtnAction() {
            if centerBtnIsCentered {
                centerBtnIsCentered = false
            }
            else {
                centerBtnIsCentered = true
                didPressCenterBtn = true
                centerViewOnUserLocation()
                
            }
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

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if didPressCenterBtn && mapIsCenteredInUser {
            didPressCenterBtn = false
        }
        else {
            if didPressCenterBtn == false {
                centerBtnIsCentered = false
//                centerBtn.setImage(UIImage(named: "centerOff"), for: .normal)
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
        }
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
        performSegue(withIdentifier: "showDetails",
                     sender: findLivingBeing(species))
    }
    
    func findLivingBeing(_ scientificName: String) -> LivingBeing?{
        for livingBeing in MVPData.sharedInstance.data {
            if livingBeing.scientificName == scientificName{
                print("Found \(livingBeing.name)")
                
                // Desculpa a gambiarra
                
                if livingBeing.beingClass == .angiosperms ||
                    livingBeing.beingClass == .angiosperms ||
                    livingBeing.beingClass == .angiosperms ||
                    livingBeing.beingClass == .angiosperms { // É planta
                    let plantType: PlantType? = {
                        switch livingBeing.beingClass {
                            case .angiosperms:
                                return PlantType.angiosperms
                            case .gimnosperms:
                                return PlantType.gimnosperms
                            case .briophyte:
                                return PlantType.briophyte
                            case .pteridophytes:
                                return PlantType.pteridophytes
                            default:
                                return nil
                        }
                    }()
                    if let type = plantType {
                        let plant = Plant(livingBeing.name,
                                          livingBeing.scientificName,
                                          livingBeing.locationOnCampus,
                                          livingBeing.coordinate,
                                          areaRadius: livingBeing.areaRadius,
                                          livingBeing.curiosity,
                                          livingBeing.photos,
                                          type,
                                          livingBeing.habitatOrBiome)
                        return plant
                    }
                    
                }
                else { // É animal
                    let animalType: AnimalType? = {
                        switch livingBeing.beingClass {
                            case .amphibian:
                                return AnimalType.amphibian
                            case .bird:
                                return AnimalType.fish
                            case .fish:
                                return AnimalType.fish
                            case .insect:
                                return AnimalType.insect
                            case .mammmal:
                                return AnimalType.mammal
                            default:
                                return nil
                        }
                    }()
                    if let type = animalType {
                        let animal = Animal(livingBeing.name,
                                            livingBeing.scientificName,
                                            livingBeing.locationOnCampus,
                                            livingBeing.coordinate,
                                            areaRadius: livingBeing.areaRadius,
                                            livingBeing.curiosity,
                                            livingBeing.photos,
                                            type,
                                            livingBeing.habitatOrBiome)
                        return animal
                    }
                }
                print("## ERRO findLivingBeing")
                return nil
            }
        }
        print("Didnt find living being")
        return nil
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selected = sender as! LivingBeing? else { print("akii"); return }
        guard let livingBeingDetailViewController = segue.destination as? LivingBeingViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        livingBeingDetailViewController.livingBeing = selected
        print("Segue ok")
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
            myCell.filterCellLabel.text = NSLocalizedString(self.animalClasses[indexPath.row].nome, comment: "")
            myCell.filterCellSwitch.isOn = self.animalClasses[indexPath.row].isOn
        case 1:
            myCell.filterCellLabel.text = NSLocalizedString(self.plantClasses[indexPath.row].nome, comment: "")
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
        self.backgroundColor = .clear
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
        case .amphibian:
            return "iconAnfibio"
        case .angiosperms:
            return "iconAngiosperma"
        case .bird:
            return "iconAve"
        case .briophyte:
            return "iconBriofita"
        case .gimnosperms:
            return "iconGimnosperma"
        case .insect:
            return "iconInseto"
        case .mammmal:
            return "iconMamifero"
        case .fish:
            return "iconPeixe"
        case .pteridophytes:
            return "iconPteridofitas"
        case .reptile:
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
    private var being: LivingBeingAnnotation
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
        self.being = annotation as! LivingBeingAnnotation
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.addSubview(self.imageView)

        //self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
        let detailLabel = self.detailCalloutAccessoryView as! UILabel
        if let str1 = self.annotation?.title , let str2 = detailLabel.text, let str3 = str1 {
            self.accessibilityLabel = "\(self.being.beingClass.rawValue) , \(str3), \(str2)"
            print("\(self.being.beingClass.rawValue) , \(str3), \(str2)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        self.delegate?.tapOn(species: self.species)
    }
    
    override func accessibilityActivate() -> Bool {
        self.delegate?.tapOn(species: self.species)
        return true
    }
}
