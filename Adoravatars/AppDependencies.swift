import Dip
import Kingfisher
import UIKit

let avatarScreenContainer = DependencyContainer()
let downloadsScreenContainer = DependencyContainer()

func createDependencies(to container: DependencyContainer) {
    
    Dip.logLevel = .Verbose
    container.register(.singleton) {
        ImageService(with: ImageDownloader.default, cache: ImageCache.default)
    }.implements(ImageServiceProtocol.self)
    container.register(.singleton) {
        AvatarNameMapper(with: "https://api.adorable.io/avatars")
    }.implements(AvatarNameMapping.self)
    container.register(.singleton) {
        ["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen Lars", "Beru Whitesun lars", "R5-D4", "Biggs Darklighter", "Obi-Wan Kenobi", "Anakin Skywalker", "Wilhuff Tarkin", "Chewbacca", "Han Solo", "Greedo", "Jabba Desilijic Tiure", "Wedge Antilles", "Jek Tono Porkins", "Yoda", "Palpatine", "Boba Fett", "IG-88", "Bossk", "Lando Calrissian", "Lobot",
         "Ackbar", "Mon Mothma", "Arvel Crynyd", "Wicket Systri Warrick", "Nien Nunb", "Qui-Gon Jinn",
         "Nute Gunray", "Finis Valorum", "Jar Jar Binks", "Roos Tarpals", "Rugor Nass", "Ric Olié",
         "Watto", "Sebulba", "Quarsh Panaka", "Shmi Skywalker", "Darth Maul", "Bib Fortuna", "Ayla Secura", "Dud Bolt", "Gasgano", "Ben Quadinaros", "Mace Windu", "Ki-Adi-Mundi", "Kit Fisto",
         "Eeth Koth", "Adi Gallia", "Saesee Tiin", "Yarael Poof", "Plo Koon", "Mas Amedda", "Gregar Typho", "Cordé", "Cliegg Lars", "Poggle the Lesser", "Luminara Unduli", "Barriss Offee",
         "Dormé", "Dooku", "Bail Prestor Organa", "Jango Fett", "Zam Wesell", "Dexter Jettster", "Lama Su", "Taun We", "Jocasta Nu", "Ratts Tyerell", "R4-P17", "Wat Tambor", "San Hill", "Shaak Ti",
         "Grievous", "Tarfful", "Raymus Antilles", "Sly Moore", "Tion Medon", "Finn", "Rey", "Poe Dameron", "BB8", "Captain Phasma", "Padmé Amidala"] as [AvatarName]
    }
    container.register(.singleton) {
        Navigator()
    }.implements(Navigation.self)

    avatarScreenContainer.register(.singleton) {
        AvatarsPresenter(with: $0, avatarNameMapper: $1, avatarNames: $2) as AvatarsPresenterProtocol
    }.resolvingProperties { (dependencyContainer, presenter) in
        guard let presenter = presenter as? AvatarsPresenter else {
            return
        }
        let view: AvatarsView = try dependencyContainer.resolve()
        presenter.view = view
    }
    avatarScreenContainer.register(.singleton) {
        AvatarsViewController(with: $0, navigator: $1)
    }.implements(AvatarsView.self)
    
    downloadsScreenContainer.register(.singleton) {
        DownloadsPresenter(with: $0, avatarNameMapper: $1, avatarNames: $2)
    }.implements(DownloadsPresenterProtocol.self) { (dependencyContainer, presenter) in
        guard let presenter = presenter as? DownloadsPresenter else {
            return
        }
        let view: NetworkView = try dependencyContainer.resolve()
        presenter.view = view
    }
    downloadsScreenContainer.register(.singleton) {
        NetworkViewController(with: $0, navigator: $1)
    }.implements(NetworkView.self)
    
    container.collaborate(with: [avatarScreenContainer, downloadsScreenContainer])
    
    let downloadsPresenter: DownloadsPresenter = try! downloadsScreenContainer.resolve()
    let imageService: ImageServiceProtocol = try! container.resolve()
    imageService.add(delegate: downloadsPresenter)
}
