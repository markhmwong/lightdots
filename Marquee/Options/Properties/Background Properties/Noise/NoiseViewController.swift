//
//  NoiseViewController.swift
//  Marquee
//
//  Created by Mark Wong on 18/10/2022.
//

import UIKit

class NoiseViewController: UIViewController {
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Preview"
        label.alpha = 0.5
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
        return label
    }()
    
    private lazy var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Speed"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    
    private lazy var speedSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(flashSpeedDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var previewBox: PreviewBox = {
        let view = PreviewBox(frame: self.view.bounds, type: .noise)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        title = "Noise"
        self.initSliderValues()
        
//        self.view.addSubview(speedSlider)
//        self.view.addSubview(speedLabel)
        self.view.addSubview(previewBox)
        self.view.addSubview(previewLabel)
        
        previewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let lateralPadding = 25.0

        previewBox.topAnchor.constraint(equalTo: self.previewLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        previewBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        previewBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        previewBox.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.15).isActive = true
        
//        speedSlider.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 10).isActive = true
//        speedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
//        speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
//
//        speedLabel.topAnchor.constraint(equalTo: previewBox.bottomAnchor, constant: 10).isActive = true
//        speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
//        speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
    }
    
    func initSliderValues() {
//        assert(false, "to do")
    }
    
    @objc func flashSpeedDidChange() {
        
    }
}
