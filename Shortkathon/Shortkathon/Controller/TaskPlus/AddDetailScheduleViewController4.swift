//
//  AddDetailScheduleViewController1.swift
//  Sergei
//
//  Created by 김사랑 on 12/28/24.
//



import UIKit

class AddDetailScheduleViewController4 : UIViewController {
    var userId =  UserDefaults.standard.string(forKey: "userIdentifier")
    var taskList : [String] = []
    var startDate : Date?
    var endDate : Date?
    var planSubId : Int?
    var selectedDate: Date?
    private weak var selectedCell: UITableViewCell?
    
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
        button.isEnabled = false
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "세분화 한 일들을 요일별로\n나눠 등록해보세요!"
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
        button.isUserInteractionEnabled = true
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
        print("페이지 4\(planSubId)")
        print(taskList)
        
    }
    
    func setUI(){
        [nextButton,mainLabel,backButton,cancelButton,progessbarImage,titleLabel, taskTableView, descriptionImage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        
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
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
    }
    
    @objc func xButtonTapped(){
        print("설명삭제")
        descriptionImage.isHidden = true
    }
    
    
    func setTable(){
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(Page4TaskTableViewCell.self, forCellReuseIdentifier: "page4")
        
    }
    
    private func updateNextButtonState() {
        // 모든 셀 확인
        var allCellsComplete = true
        
        for i in 0..<taskList.count {
            guard let cell = taskTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? Page4TaskTableViewCell else {
                allCellsComplete = false
                break
            }
            
            // 날짜와 시간이 모두 설정되었는지 확인
            if cell.dateLabel.text == "날짜" || cell.timeLabel.text == "시간" {
                allCellsComplete = false
                break
            }
        }
        
        // 버튼 상태 업데이트
        nextButton.isEnabled = allCellsComplete
        nextButton.backgroundColor = allCellsComplete ?
        #colorLiteral(red: 0.4862745098, green: 0.6666666667, blue: 1, alpha: 1) :
        #colorLiteral(red: 0.5591031909, green: 0.571234405, blue: 0.5998923779, alpha: 1)
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
        postPlanSubDetail()
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
        cell.delegate = self // Delegate 연결
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
}


extension AddDetailScheduleViewController4: Page4TaskTableViewCellDelegate {
    func didTapAddButton(in cell: Page4TaskTableViewCell) {
        // 버튼이 눌린 셀의 인덱스를 가져옵니다.
        guard let indexPath = taskTableView.indexPath(for: cell) else { return }
        
        // 예: 새로운 ViewController로 이동
        let selectedTask = taskList[indexPath.row]
        print("Button tapped for task: \(selectedTask)")
        
        let detailVC = TimeModalViewController() // 이동할 ViewController
        detailVC.delegate = self
        detailVC.availableStartDate = startDate
        detailVC.availableEndDate = endDate
        selectedCell = cell  // 선택된 셀 저장
        
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .crossDissolve
        present(detailVC, animated: true, completion: nil)
    }
}


extension AddDetailScheduleViewController4: TimeModalViewControllerDelegate {
    func didSelectDateTime(date: Date, startTime: Date?, endTime: Date?) {
        // 현재 선택된 셀 업데이트
        guard let cell = selectedCell as? Page4TaskTableViewCell else { return }
        
        // 날짜 포맷터
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 날짜 설정
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        // 시간 설정
        if let start = startTime, let end = endTime {
            dateFormatter.dateFormat = "a h:mm"
            let startTimeString = dateFormatter.string(from: start)
            let endTimeString = dateFormatter.string(from: end)
            cell.timeLabel.text = "\(startTimeString)~\(endTimeString)"
        }
        
        updateNextButtonState()
    }
}


//MARK: - 서버 통신

extension AddDetailScheduleViewController4 {
    func postPlanSubDetail() {
        guard let planSubId = planSubId else {
            print("❌ planSubId가 없습니다")
            return
        }
        
        guard let userId = userId else {return}
        
        
        print("\n🔍 API 요청 정보 ===============")
        print("📡 URL: /plansubdetail/\(planSubId)")
        
        var details: [DetailTask] = []
        
        for i in 0..<taskList.count {
            if let cell = taskTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? Page4TaskTableViewCell,
               let dateText = cell.dateLabel.text,
               let timeText = cell.timeLabel.text {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.dateFormat = "yyyy년 M월 d일"
                
                if let date = dateFormatter.date(from: dateText) {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: date)
                    
                    let times = timeText.split(separator: "~").map(String.init)
                    if times.count == 2 {
                        let timeFormatter = DateFormatter()
                        timeFormatter.locale = Locale(identifier: "ko_KR")
                        timeFormatter.dateFormat = "a h:mm"
                        
                        if let startTime = timeFormatter.date(from: times[0].trimmingCharacters(in: .whitespaces)),
                           let endTime = timeFormatter.date(from: times[1].trimmingCharacters(in: .whitespaces)) {
                            
                            timeFormatter.dateFormat = "HH:mm"
                            let formattedStartTime = timeFormatter.string(from: startTime)
                            let formattedEndTime = timeFormatter.string(from: endTime)
                            
                            let content = taskList[i]
                            let detail = DetailTask(
                                content: content,
                                date: formattedDate,
                                startTime: formattedStartTime,
                                endTime: formattedEndTime
                            )
                            details.append(detail)
                            
                            print("✅ 변환된 데이터:")
                            print("- Content: \(content)")
                            print("- Date: \(formattedDate)")
                            print("- Start Time: \(formattedStartTime)")
                            print("- End Time: \(formattedEndTime)")
                        }
                    }
                }
            }
        }
        
        let planSubDetail = PlanSubDetail(details: details)
        
        // JSON 데이터로 변환
        do {
            let jsonData = try JSONEncoder().encode(planSubDetail)
            
            // 디버깅을 위한 JSON 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("\n📦 전송될 JSON 데이터:")
                print(jsonString)
            }
            
            // APIService 호출
            APIService.shared.postData(
                endpoint: "/plansubdetail/\(userId)/\(planSubId)",
                jsonData: jsonData
            ) { (result: Result<APIResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("✅ 세부 일정 등록 성공: \(response)")
                        let vc = SchedulemodalController()
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                        
                    case .failure(let error):
                        print("❌ 세부 일정 등록 실패: \(error.localizedDescription)")
                        let alert = UIAlertController(
                            title: "오류",
                            message: "일정 등록에 실패했습니다. 다시 시도해주세요.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        } catch {
            print("❌ JSON 변환 실패: \(error)")
            let alert = UIAlertController(
                title: "오류",
                message: "데이터 처리 중 오류가 발생했습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
    
    
    
}




struct PlanSubDetail: Codable {
    let details: [DetailTask]
}

struct DetailTask: Codable {
    let content: String
    let date: String
    let startTime: String
    let endTime: String
}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "JSONSe   rialization", code: -1, userInfo: nil)
        }
        return dictionary
    }
}
