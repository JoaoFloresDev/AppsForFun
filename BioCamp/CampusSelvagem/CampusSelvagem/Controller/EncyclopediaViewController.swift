//
//  EncyclopediaViewController.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 19/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit

class EncyclopediaViewController: UIViewController  {
    //MARK: Properties
    var animals = [Animal]()
    var filteredAnimals = [Animal]()
    var plants = [Plant]()
    var filteredPlants = [Plant]()
    
    let sectionsAnimals = [AnimalType.amphibian.rawValue,
                           AnimalType.bird.rawValue,
                           AnimalType.mammal.rawValue,
                           AnimalType.reptile.rawValue,
                            AnimalType.insect.rawValue,
                            AnimalType.fish.rawValue]
    let sectionsPlants = [PlantType.angiosperms.rawValue,
                          PlantType.gimnosperms.rawValue,
                          PlantType.briophyte.rawValue,
                          PlantType.pteridophytes.rawValue]
    
    var dictAnimal: [String: [LivingBeing]] = [:]
    var dictPlant: [String: [LivingBeing]] = [:]
    
    var speciesList: [[LivingBeing]]  = []
    var sectionsList: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MapView stuff
    var searchForPlants: Bool = false
    var nameToBeSearched: String?
    var searchForName: Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Loading the living beings, otherwise load sample data.
        if let savedAnimals = loadAnimals() {
            animals += savedAnimals
        }
        else {
            loadSampleAnimals()
        }
        
        if let savedPlants = loadPlants() {
            plants += savedPlants
        }
        else {
            loadSamplePlants()
        }
        
        
        
        for animal in animals {
            
            var arrType = dictAnimal[animal.type.rawValue]
            
            if arrType != nil {
                arrType?.append(animal)
                dictAnimal[animal.type.rawValue] = arrType!
            } else {
                dictAnimal[animal.type.rawValue] = [animal]
            }
            
        }
        
        for plant in plants {
            
            var arrType = dictPlant[plant.type.rawValue]
            
            if  arrType != nil{
                arrType?.append(plant)
                dictPlant[plant.type.rawValue] = arrType!
            } else {
                dictPlant[plant.type.rawValue] = [plant]
            }
            
        }

        filterSpecies(sectionList: sectionsAnimals, speciesCatalog: dictAnimal)
        
        //Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search for the name of the animal", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        self.tableView.sectionHeaderHeight =  UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 25;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (searchForName) {
            
            if searchForPlants {
                self.segmentedControl.selectedSegmentIndex = 1
            }
            else {
                self.segmentedControl.selectedSegmentIndex = 0
            }
            self.searchController.isActive = true
            self.searchController.searchBar.text = nameToBeSearched
            self.searchController.resignFirstResponder()
            
            self.tableView.allowsSelection = true
            self.tableView.isUserInteractionEnabled = true
            
            self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            
            searchForName = false
        }
    }
    
    //MARK: Private Methods
    private func saveLivingBeings() {
        //Attempts to archive the living beings array to a specific location, and returns true if it’s successful.
        if segmentedControl.selectedSegmentIndex == 0 { //fauna
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(animals, toFile: Animal.ArchiveURL.path)
        } else { //flora
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(plants, toFile: Plant.ArchiveURL.path)
        }
    }
    
    private func loadAnimals() -> [Animal]? {
        //Unarchive the object stored at the path
        return NSKeyedUnarchiver.unarchiveObject(withFile: Animal.ArchiveURL.path) as? [Animal]
    }
    
    private func loadSampleAnimals(){
//        let photo1 = UIImage(named: "corujas1")
//        let photo2 = UIImage(named: "corujas2")
        
        
        for being in MVPData.sharedInstance.data {
            if (being.beingClass == .amphibian ||  being.beingClass == .fish || being.beingClass == .bird || being.beingClass == .mammmal ||  being.beingClass == .insect || being.beingClass == .reptile) {
                
                let animalType: AnimalType = {
                    switch being.beingClass {
                        case .amphibian:
                            return .amphibian
                    case .bird:
                            return .bird
                    case .mammmal:
                            return .mammal
                        case .reptile:
                            return .reptile
                    case .fish:
                            return .fish
                    case .insect:
                            return .insect
                        case .briophyte:
                            return .amphibian
                        case .pteridophytes:
                            return .amphibian
                        case .angiosperms:
                            return .amphibian
                        case .gimnosperms:
                            return .amphibian
                    }
                }()
                let animal = Animal(being.name, being.scientificName, being.locationOnCampus, being.coordinate, areaRadius: being.areaRadius, being.curiosity, being.photos, animalType, being.habitatOrBiome)
                
                animals.append(animal)
            }
        }
//        var photos: [UIImage] = []
//
//        photos.append(photo1!)
//        photos.append(photo2!)
        
//        let animal = Animal("Coruja Buraqueira",
//                            "Athene cunicularia",
//                            "Estacionamento da FEAGRI",
//                            "Os machos permanecem fora do ninho com a função de vigiar, descansar e observar. A presença da fêmea é mais oculta, devido a sua permanência no interior da toca.",
//                            photos,
//                            .bird,
//                            "Tem hábito diurno e noturno. Durante a manhã elas são inativas na maior parte do tempo ou tem comportamentos de vigília contra possíveis predadores.")
//
//
//        let harpia = Animal("Harpia",
//                            "Athene cunicularia",
//                            "Estacionamento da FEAGRI",
//                            "Os machos permanecem fora do ninho com a função de vigiar, descansar e observar. A presença da fêmea é mais oculta, devido a sua permanência no interior da toca.",
//                            photos,
//                            .bird,
//                            "Tem hábito diurno e noturno. Durante a manhã elas são inativas na maior parte do tempo ou tem comportamentos de vigília contra possíveis predadores.")
//
//        let jacare = Animal("Jacaré",
//                            "Athene cunicularia",
//                            "Estacionamento da FEAGRI",
//                            "Os machos permanecem fora do ninho com a função de vigiar, descansar e observar. A presença da fêmea é mais oculta, devido a sua permanência no interior da toca.",
//                            photos,
//                            .reptile,
//                            "Tem hábito diurno e noturno. Durante a manhã elas são inativas na maior parte do tempo ou tem comportamentos de vigília contra possíveis predadores.")
        
        
        
        //animals += [animal,harpia,jacare]
    }
    
    private func loadPlants() -> [Plant]? {
        //Unarchive the object stored at the path
        return NSKeyedUnarchiver.unarchiveObject(withFile: Plant.ArchiveURL.path) as? [Plant]
    }
    
    private func loadSamplePlants(){
//        let photo1 = UIImage(named: "flor1")
//        let photo2 = UIImage(named: "flor2")
//
//        var photos: [UIImage] = []
//
//        photos.append(photo1!)
//        photos.append(photo2!)
//
//        let plant = Plant("Abricó-de-macaco",
//                            "Couroupita guianensis",
//                            "Praça da Paz",
//                            "Podem ter altura média entre 8 e 15 metros",
//                            photos,
//                            .flower,
//                            "Mata Atlântica")
//
//        plants += [plant]
        
        for being in MVPData.sharedInstance.data {
            if (being.beingClass == .briophyte ||  being.beingClass == .pteridophytes || being.beingClass == .gimnosperms || being.beingClass == .angiosperms) {
                
                let plantType: PlantType = {
                    switch being.beingClass {
                    case .amphibian:
                        return .angiosperms
                    case .bird:
                        return .angiosperms
                    case .mammmal:
                        return .angiosperms
                    case .reptile:
                        return .angiosperms
                    case .fish:
                        return .angiosperms
                    case .insect:
                        return .angiosperms
                    case .briophyte:
                        return .briophyte
                    case .pteridophytes:
                        return .pteridophytes
                    case .angiosperms:
                        return .angiosperms
                    case .gimnosperms:
                        return .gimnosperms
                    }
                }()
                let plant = Plant(being.name, being.scientificName, being.locationOnCampus, being.coordinate, areaRadius: being.areaRadius, being.curiosity, being.photos, plantType, being.habitatOrBiome)
                
                plants.append(plant)
            }
        }
    }
    
    //MARK: Search Controller's Methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if segmentedControl.selectedSegmentIndex == 0 { //fauna
            filteredAnimals = animals.filter({( animal : Animal) -> Bool in
                return animal.name.lowercased().contains(searchText.lowercased())
            })
        } else { //flora
            filteredPlants = plants.filter({( plant : Plant) -> Bool in
                return plant.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterSpecies(sectionList: [String], speciesCatalog:[String:[LivingBeing]]) {
        sectionsList = sectionList.filter { (sectionName) -> Bool in
            return (speciesCatalog[sectionName] ?? []).count > 0
        }
        speciesList = sectionsList.map { (sectionName) -> [LivingBeing] in
            return speciesCatalog[sectionName] ?? []
        }
    }
    
    @IBAction func seg(_ sender: Any) {
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            filterSpecies(sectionList: sectionsAnimals, speciesCatalog: dictAnimal)

            tableView.reloadData()
            searchController.searchBar.placeholder = NSLocalizedString("Search for the name of the animal", comment: "")
            break
            
        case 1:
            filterSpecies(sectionList: sectionsPlants, speciesCatalog: dictPlant)
            
            tableView.reloadData()
            searchController.searchBar.placeholder = NSLocalizedString("Search for the name of the plant", comment: "")
            break
        default:
            break
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let selected =  sender as?  LivingBeing else {
            return 
        }
        
        guard let livingBeingDetailViewController = segue.destination as? LivingBeingViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
    
         livingBeingDetailViewController.livingBeing = selected

    }
}

//MARK: Extension
extension EncyclopediaViewController: UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: Table view data source
    func countValidate(_ count: Int) throws {
        if count < 0 {
            throw SizeExpectedErrors.negativeSize
        }
        else if count > sectionsList.count {
            throw SizeExpectedErrors.oversize
        }
        else if count != sectionsList.count {
            throw SizeExpectedErrors.differentSize
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 1
        
        if !isFiltering() {
            count = sectionsList.count
        }
        
        do {
           try countValidate(count)
        } catch {
            print("Error func numberOfSections(in tableView: UITableView)")
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if isFiltering() {
            if segmentedControl.selectedSegmentIndex == 0 { //fauna
                count = filteredAnimals.count
            } else { //flora
                count = filteredPlants.count
            }
        } else {
            count = speciesList[section].count
        }
        
        do {
           try countValidate(count)
        } catch {
            print("Error func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)")
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewCell"
        var livingBeing: LivingBeing
        
        // Downcast
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LivingBeingTableViewCell  else { //safely unwraps the optional
            fatalError("The dequeued cell is not an instance of LivingBeingTableViewCell.")
        }
        
        
        // Fetches the appropriate living being for the data source layout.
        if isFiltering() {
            if segmentedControl.selectedSegmentIndex == 0 { //fauna
                livingBeing = filteredAnimals[indexPath.row]
            } else { //flora
                livingBeing = filteredPlants[indexPath.row]
            }
        } else {
            livingBeing = speciesList[indexPath.section][indexPath.row]
        }
        
        // configuring the cell -> sets each of the views in the table view cell to display the corresponding data
        cell.nameLabel.text = livingBeing.name
        cell.photoImageView.image = livingBeing.photos[0]
        cell.scientificNameLabel.text = livingBeing.scientificName
        
        cell.configureCellVoiceOver(livingBeing)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        
        if !isFiltering() {
            text = NSLocalizedString("\(sectionsList[section])", comment: "")
        }
        
        return text
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("OIE")
        var livingBeing: LivingBeing
        
        // Fetches the appropriate living being for the data source layout.
        if isFiltering() {
            if segmentedControl.selectedSegmentIndex == 0 { //fauna
                livingBeing = filteredAnimals[indexPath.row]
            } else { //flora
                livingBeing = filteredPlants[indexPath.row]
            }
        } else {
            livingBeing = speciesList[indexPath.section][indexPath.row]
        }
        
        self.performSegue(withIdentifier: "showDetailSegue", sender: livingBeing)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
    }
}

enum SizeExpectedErrors: Error {
    case negativeSize
    case oversize
    case differentSize
}
