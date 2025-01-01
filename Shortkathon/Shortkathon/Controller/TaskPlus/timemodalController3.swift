//
//  timemodalController2.swift
//  Shortkathon
//
//  Created by 김사랑 on 12/30/24.
//

//
//  timemodalController.swift
//  Shortkathon
//
//  Created by 김사랑 on 12/30/24.
//

import UIKit

class timemodalController3: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        view.layer.cornerRadius = 12.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.text = "시작 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Icon-3")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.337254902, green: 0.6156862745, blue: 1, alpha: 1), for: .normal)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timedatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = .white
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupUI()
        // DatePicker의 값이 변경될 때마다 updateTimeLabel 메서드 호출
        timedatePicker.addTarget(self, action: #selector(updateTimeLabel), for: .valueChanged)
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nextButton)
        containerView.addSubview(cancelButton)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timedatePicker)

        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 333),
            containerView.heightAnchor.constraint(equalToConstant: 331),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
            
            nextButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
            nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 39),
            
            timeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            timedatePicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            timedatePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            timedatePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            timedatePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    // timeLabel 업데이트를 위한 메서드
    @objc private func updateTimeLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a HH:mm"
        timeLabel.text = dateFormatter.string(from: timedatePicker.date)
    }
    
    
    func buttonTap(){
        nextButton.addTarget(self, action: #selector(moveToNext), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelModal), for: .touchUpInside)
    }
    
    @objc func moveToNext(){
        let vc = timemodalController2()
        present(vc,animated: true)
    }
    
    @objc func cancelModal(){
        dismiss(animated: true, completion: nil)
    }
}
    
   
