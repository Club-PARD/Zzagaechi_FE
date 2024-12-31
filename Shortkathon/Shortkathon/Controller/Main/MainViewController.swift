import UIKit

class MainViewController : UIViewController {
    //MARK: - property
    let apiService = APIService.shared
    var dailySchedule: DailySchedule?
    var userId = UserDefaults.standard.string(forKey: "userIdentifier")
    enum TaskType {
        case plan
        case detail
    }
    
    var taskData : [(type: TaskType, task : Any)] = []
    
    
    
    
    var toDayTask : [String] = ["로고 레퍼런스 찾기","로고 틀 짜기", "하나로 마트 가서 세제 사기"] // 더미 데이터
    
    
    //    var taskData: [(type: TaskType, task: Any)] = []
    
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 35)
        label.text = "작은 한 걸음이\n큰 변화를 만듭니다,\n오늘도 파이팅!"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let toDoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 24)
        label.text = "오늘의 할 일"
        return label
    }()
    
    
    let image1 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "n 최치최최종")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let image2 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "O쵲옹")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let image3 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "n 최치최최종종")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let image4 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "a 쵲옹")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    
    let taskTableView : UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        view.separatorStyle = .none
        return view
    }()
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        fetchDailySchedule()
        setUI()
        setTable()
        startFloatingAnimations()
    }
    
    //MARK: - function
    func setUI(){
        [titleLabel, toDoLabel,image1,image2,image3,image4,taskTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.bringSubviewToFront(titleLabel) // titleLabel을 항상 위로
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor ,constant: 102),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27),
            
            toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 140 ),
            toDoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:   26),
            
            image1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            image1.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            image1.widthAnchor.constraint(equalToConstant: 188),
            image1.heightAnchor.constraint(equalToConstant: 191),
            
            image2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 149),
            image2.topAnchor.constraint(equalTo: view.topAnchor, constant: 336),
            image2.widthAnchor.constraint(equalToConstant: 123),
            image2.heightAnchor.constraint(equalToConstant: 89),
            
            
            image3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -13),
            image3.topAnchor.constraint(equalTo: view.topAnchor, constant: 222),
            image3.widthAnchor.constraint(equalToConstant: 130),
            image3.heightAnchor.constraint(equalToConstant: 130),
            
            image4.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            image4.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            image4.widthAnchor.constraint(equalToConstant: 125),
            image4.heightAnchor.constraint(equalToConstant: 138),
            
            taskTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTableView.widthAnchor.constraint(equalToConstant: 345),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            taskTableView.topAnchor.constraint(equalTo: toDoLabel.bottomAnchor, constant: 27 ),
            
        ])
    }
    
    
    func setTable(){
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "mainTableViewCell")
    }
}


//MARK: - tableview Extension

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        let taskItem = taskData[indexPath.row]
        
        switch taskItem.type {
        case .plan:
            if let plan = taskItem.task as? Plan {
                cell.configure(with: plan, type: .plan)
            }
        case .detail:
            if let detail = taskItem.task as? Detail {
                cell.configure(with: detail, type: .detail)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
}




//MARK: - 이미지 애니메이션
extension MainViewController {
    private func startFloatingAnimations(repeatCount: Int = 3) {
        guard repeatCount > 0 else { return }
        
        let duration: TimeInterval = 1.0
        let delay: TimeInterval = 0.2
        let totalDuration: TimeInterval = 5.0
        
        [image1, image2, image3, image4].enumerated().forEach { index, imageView in
            // 초기 위로 떠오르는 애니메이션
            UIView.animate(withDuration: duration,
                           delay: delay * Double(index),
                           options: [.curveEaseInOut],
                           animations: {
                imageView.transform = CGAffineTransform(translationX: 0, y: -20)
            }) { _ in
                // 5초 후에 점점 느려지면서 원위치로
                UIView.animate(withDuration: totalDuration,
                               delay: 0,
                               options: [.curveEaseOut],
                               animations: {
                    // dampingRatio를 사용하여 스프링 효과 추가
                    UIView.animate(withDuration: 4.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [],
                                   animations: {
                        imageView.transform = .identity
                    }, completion: nil)
                }, completion: nil)
            }
        }
        
        // 다음 실행을 위한 재귀 호출 (딜레이 포함)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration - 2.0) {
            self.startFloatingAnimations(repeatCount: repeatCount - 1)
        }
    }
    
}



//MARK: - 서버 통신 코드
extension MainViewController {
    private func fetchDailySchedule() {
                let today = Date().toDateString()
//        let today = "2024-01-03"
                guard let userId = userId else { return }
//        let userId = "user2"
        let endpoint = "/daily/\(userId)/\(today)"
        print("today : \(today)")
        print("endpoint : \(endpoint)")
        apiService.get(endpoint: endpoint) { [weak self] (result: Result<DailySchedule, Error>) in
            switch result {
            case .success(let schedule):
                self?.dailySchedule = schedule
                print("✅ 일정 데이터 수신 성공")
                print("총 일정 수: \(schedule.totalCount)")
                print("완료된 일정 수: \(schedule.completedCount)")
                print(schedule)
                DispatchQueue.main.async {
                    self?.updateUI()
                }
                
            case .failure(let error):
                print("❌ 일정 조회 실패: \(error.localizedDescription)")
                // 에러 처리 - 예: 알림창 표시
                DispatchQueue.main.async {
                    //                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: "일정을 불러오는데 실패했습니다.\n\(message)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    private func updateUI() {
        
        
        guard let schedule = dailySchedule else { return }
//        taskData = []
        
        schedule.details.forEach { detail in
            taskData.append((type: .detail, task: detail))
        }
        
        schedule.plans.forEach { plan in
            taskData.append((type: .plan, task: plan))
        }
        
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
}
