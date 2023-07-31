//
//  BackgroundPropertiesViewModel.swift
//  Marquee
//
//  Created by Mark Wong on 9/10/2022.
//

import UIKit

final class Symbol {
    static let backgroundOptionsSymbol: String = "ellipsis"
}

extension BackgroundPropertiesViewModel: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if viewController.isKind(of: BackgroundSolidColourPicker.self) {
            // solid colour
            print("solid background")
            LedOptions.shared.updateBackgroundColour(hexColor: viewController.selectedColor.hexStringFromColor())
        }
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        print("did select")
        LedOptions.shared.updateBackgroundColour(hexColor: viewController.selectedColor.hexStringFromColor())
    }
}

class BackgroundPropertiesViewModel: NSObject  {
    
    struct ColourContentItem: Hashable {
        var name: String
        var id: UUID = UUID()
        var section: BackgroundProperties
        
        var solidColour: UIColor? = nil
        
        init(name: String, section: BackgroundProperties) {
            self.name = name
            self.section = section
        }
        
        init(name: String, section: BackgroundProperties, solidColour: UIColor) {
            self.name = name
            self.section = section
            self.solidColour = solidColour
        }
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<BackgroundProperties, ColourContentItem>! = nil
    
    private func configureSolidCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertySolidCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertySolidCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureShimmerCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertyShimmerCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertyShimmerCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureGradientCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertyGradientCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertyGradientCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureFlashCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertyFlashCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertyFlashCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureRainbowNoiseCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertyRainbowNoiseCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertyRainbowNoiseCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureNoiseCellRegistration() -> UICollectionView.CellRegistration<BackgroundPropertyNoiseCell, ColourContentItem> {
        let cellConfig = UICollectionView.CellRegistration<BackgroundPropertyNoiseCell, ColourContentItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView, coordinator: BackgroundEditingCoordinator) {
        let solidRego = self.configureSolidCellRegistration()
        let gradientRego = self.configureGradientCellRegistration()
        let shimmerRego = self.configureShimmerCellRegistration()
        let flashRego = self.configureFlashCellRegistration()
        let raindbowRego = self.configureRainbowNoiseCellRegistration()
        let noiseRego = self.configureNoiseCellRegistration()
        
        diffableDataSource = UICollectionViewDiffableDataSource<BackgroundProperties, ColourContentItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if indexPath.section == BackgroundProperties.shimmer.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: shimmerRego, for: indexPath, item: item)
                cell.item = item
                cell.coordinator = coordinator
                return cell
            } else if indexPath.section == BackgroundProperties.solid.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: solidRego, for: indexPath, item: item)
                cell.item = item
                cell.coordinator = coordinator
                cell.colourPickerViewModel = self
                return cell
            } //else if indexPath.section == BackgroundProperties.gradient.rawValue {
//                let cell = collectionView.dequeueConfiguredReusableCell(using: gradientRego, for: indexPath, item: item)
//                cell.coordinator = coordinator
//                cell.item = item
//                return cell
            else if indexPath.section == BackgroundProperties.flash.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: flashRego, for: indexPath, item: item)
                cell.coordinator = coordinator
                cell.item = item
                return cell
            } else if indexPath.section == BackgroundProperties.rainbowNoise.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: raindbowRego, for: indexPath, item: item)
                cell.coordinator = coordinator
                cell.item = item
                return cell
            } else if indexPath.section == BackgroundProperties.noise.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: noiseRego, for: indexPath, item: item)
                cell.coordinator = coordinator
                cell.item = item
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: flashRego, for: indexPath, item: item)
                cell.item = item
                return cell
            }
        }
        diffableDataSource.apply(configureSnapshot())
    }
    
    private func createItems() -> [ColourContentItem] {
        var items: [ColourContentItem] = []
        for (index, bgp) in BackgroundProperties.allCases.enumerated() {
            if BackgroundProperties.solid == BackgroundProperties(rawValue: index) {
                let hexString = LedOptions.shared.loadSolidBackgroundColour()
                print("\(hexString) hexString")
                items.append(ColourContentItem(name: bgp.name, section: BackgroundProperties.init(rawValue: index)!, solidColour: UIColor.hexStringToUIColor(hex: hexString)))
            } //else if BackgroundProperties.gradient == BackgroundProperties(rawValue: index) {
                //items.append(ColourContentItem(name: bgp.name, section: BackgroundProperties.init(rawValue: index)!))
            else if BackgroundProperties.rainbowNoise == BackgroundProperties(rawValue: index) {
                items.append(ColourContentItem(name: bgp.name, section: BackgroundProperties.init(rawValue: index)!))
            } else if BackgroundProperties.noise == BackgroundProperties(rawValue: index) {
                items.append(ColourContentItem(name: bgp.name, section: BackgroundProperties.init(rawValue: index)!))
            }
            else {
                items.append(ColourContentItem(name: bgp.name, section: BackgroundProperties.init(rawValue: index)!))
            }
        }
        return items
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<BackgroundProperties, ColourContentItem> {
        var snapshot = NSDiffableDataSourceSnapshot<BackgroundProperties, ColourContentItem>()
        snapshot.appendSections([.solid, .flash, .noise, .rainbowNoise, .shimmer])
        for bgp in self.createItems() {
            snapshot.appendItems([bgp], toSection: bgp.section)
        }
        return snapshot
    }
}

class BackgroundPropertyCell: UICollectionViewCell {
    
    override var isSelected: Bool  {
        didSet {
            if isSelected {
                self.showIcon()
            } else {
                self.hideIcon()
            }
//            self.showIcon()
        }
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isHidden = true
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let selectedBg = UIView(frame: bounds)
        selectedBg.backgroundColor = UIColor.neoGray.withAlphaComponent(0.5)
        self.selectedBackgroundView = selectedBg
        
        self.contentView.addSubview(icon)
        icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func showIcon() {
        icon.isHidden = false
    }
    
    func hideIcon() {
        icon.isHidden = true
    }
    
}

/*
 
 MARK: Solid Cell
 
 */
class BackgroundPropertySolidCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var colourPickerVc: BackgroundSolidColourPicker! = nil
    
    var colourPickerViewModel: BackgroundPropertiesViewModel! = nil
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    private var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.textColor = UIColor.textColor
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = UIImage(systemName: Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.alpha = 0.7
        button.tintColor = .textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSolidColour), for: .touchDown)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {

        contentView.addSubview(optionsButton)
        contentView.addSubview(backgroundTypeLabel)
        
        optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
    
    private func configure() {
        backgroundTypeLabel.text = item.name
        backgroundTypeLabel.textColor = item.solidColour
    }
    
    @objc func handleSolidColour() {
        let vc = BackgroundSolidColourPicker()
        colourPickerVc = vc
        colourPickerVc.delegate = colourPickerViewModel
        coordinator.showSolidOptions(vc: vc)
    }
}

/*
 MARK: Shimmer Cell
 */
class BackgroundPropertyShimmerCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShimmerOptions), for: .touchDown)
        button.alpha = 0.7
        return button
    }()
    
    lazy var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)
        contentView.addSubview(optionsButton)
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    
    func configure() {
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleShimmerOptions() {
        
        if SubscriptionService.shared.proStatus() {
            coordinator.showShimmerOptions()
        } else {
            coordinator.showProPurchase()
        }
    }
    
}

/*
 MARK: Gradient - incomplete don't ship
 */
class BackgroundPropertyGradientCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    lazy var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.tintColor = .textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGradientOptions), for: .touchDown)
        button.alpha = 0.7
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)
        contentView.addSubview(optionsButton)
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    
    private func configure() {
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleGradientOptions() {
        
    }
    
    
}

/*
 
 MARK: Flash
 */
class BackgroundPropertyFlashCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    lazy var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.alpha = 0.7
        button.tintColor = .textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFlashColour), for: .touchDown)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)
        contentView.addSubview(optionsButton)
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        optionsButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    
    func configure() {
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleFlashColour() {
        
        if SubscriptionService.shared.proStatus() {
            coordinator.showFlashOptions()
        } else {
            coordinator.showProPurchase()
        }
    }
    
}

/*
 MARK: Rainbow Noise Cell
 */
class BackgroundPropertyRainbowNoiseCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.tintColor = .textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShimmerOptions), for: .touchDown)
        button.alpha = 0.7
        return button
    }()
    
    lazy var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)
        contentView.addSubview(optionsButton)
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    
    func configure() {
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleShimmerOptions() {
        if SubscriptionService.shared.proStatus() {
            coordinator.showRainbowNoiseOptions()
        } else {
            coordinator.showProPurchase()
        }
    }
    
}

/*
 MARK: Noise Cell
 */
class BackgroundPropertyNoiseCell: BackgroundPropertyCell {
    
    var item: BackgroundPropertiesViewModel.ColourContentItem! = nil {
        didSet {
            self.configure()
        }
    }
    
    var coordinator: BackgroundEditingCoordinator! = nil
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.tintColor = .textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShimmerOptions), for: .touchDown)
        button.alpha = 0.7
        return button
    }()
    
    lazy var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)
        contentView.addSubview(optionsButton)
        
        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    
    func configure() {
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleShimmerOptions() {
        if SubscriptionService.shared.proStatus() {
            coordinator.showNoiseOptions()
        } else {
            coordinator.showProPurchase()
        }
    }
    
}
