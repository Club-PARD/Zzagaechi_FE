//
//  AddDetailScheduleViewController1.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//



import UIKit

class AddDetailScheduleViewController4 : UIViewController {
    
    var taskList : [String] = []
    var startDate : Date?
    var endDate : Date?
    
    var selectedDate: Date?
    
    private var dates: [(date: String, day: String)] = []
    
    enum DateCellSate {
        case nomal
        case selected
        case hasTask
    }
    
    
    enum TaskCellSate {
        case normal
        case selected
        case timeSet
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 일정 등록"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Icon-3")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.setTitleColor(#colorLiteral(red: 1, green: 0.2745098039, blue: 0.2745098039, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let progessbarImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progess4")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 15)
        button.backgroundColor = #colorLiteral(red: 0.5591031909, green: 0.571234405, blue: 0.5998923779, alpha: 1)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "할 일들을 요일별로\n배분해보아요!"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 28)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionImage : UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "description")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let xButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let taskTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()

    
    //MARK: - 메인
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1372549087, green: 0.1372549087, blue: 0.1372549087, alpha: 1)
        buttonTapped()
        setUI()
        setTable()
        generateDates()
    
        print(taskList)
        
    }
    
    func setUI(){
        [nextButton,mainLabel,backButton,cancelButton,progessbarImage,titleLabel, taskTableView, descriptionImage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        descriptionImage.addSubview(xButton)
        
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 33),
            
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -28),
            
            progessbarImage.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 60),
            progessbarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            titleLabel.topAnchor.constraint(equalTo: progessbarImage.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 31),
            
            descriptionImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23),
            descriptionImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            descriptionImage.widthAnchor.constraint(equalToConstant: 217),
            descriptionImage.heightAnchor.constraint(equalToConstant: 51),
            
            xButton.topAnchor.constraint(equalTo: descriptionImage.topAnchor, constant: 7),
            xButton.trailingAnchor.constraint(equalTo: descriptionImage.trailingAnchor, constant: -10),
            xButton.widthAnchor.constraint(equalToConstant: 6),
            xButton.heightAnchor.constraint(equalToConstant: 6),
            
            
            taskTableView.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 6),
            taskTableView.heightAnchor.constraint(equalToConstant: 281),
            taskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29),
            taskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -49),
            nextButton.heightAnchor.constraint(equalToConstant: 46),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),

            
        ])
    }
    
    private func generateDates(){
        guard let start = startDate, let end = endDate else { return }
        dateFormatter.dateFormat = "d"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E"
        dayFormatter.locale = Locale(identifier: "ko_KR")
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        guard let dayCount = components.day else { return }
        
        dates = (0...dayCount).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: start)!
            let dateString = dateFormatter.string(from: date)
            let dayString = dayFormatter.string(from: date)
            return (date: dateString, day: dayString)
        }
        
        dateFormatter.dateFormat = "M월"
    }

    
    
    func buttonTapped(){
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(moveToMain), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(movoToNext), for: .touchUpInside)
    }
    
    func setTable(){
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(Page4TaskTableViewCell.self, forCellReuseIdentifier: "page4")
        
    }
    
    @objc func dismissVC() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func moveToMain() {
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false)
    }
    
    @objc func movoToNext(){
        let vc = SchedulemodalController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
}


extension AddDetailScheduleViewController4 : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "page4", for: indexPath) as? Page4TaskTableViewCell else {
            return UITableViewCell()
        }
        
        cell.taskLabel.text = taskList[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
}
