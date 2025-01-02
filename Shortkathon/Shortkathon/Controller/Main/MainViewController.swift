import UIKit

class MainViewController : UIViewController {
    //MARK: - property
    let apiService = APIService.shared
    var dailySchedule: DailySchedule?
    private var toggledPlanIds: Set<Int> = []
    private var toggledDetailIds: Set<Int> = []
    
    var userId = UserDefaults.standard.string(forKey: "userIdentifier")
    enum TaskType {
        case plan
        case detail
    }
    
    var taskData : [(type: TaskType, task : Any)] = []
    var toDayTask : [String] = ["로고 레퍼런스 찾기","로고 틀 짜기", "하나로 마트 가서 세제 사기"]
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 35)
        label.text = "작은 한 걸음이\n큰 변화를 만듭니다,\n오늘도 파이팅!"
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let toDoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 24)
        label.text = "오늘의 할 일"
        label.textColor = .white
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
    
    
    let resetButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        fetchDailySchedule()
        setUI()
        setTable()
        startFloatingAnimations()
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendToggledTasks()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 데이터 새로고침
        fetchDailySchedule()
    }
    
    //MARK: - function
    func setUI(){
        [titleLabel, toDoLabel,image1,image2,image3,image4,taskTableView,resetButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.bringSubviewToFront(titleLabel) // titleLabel을 항상 위로
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor ,constant: 102),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27),
            
            toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 140 ),
            toDoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:   26),
            
            image1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor ,constant: -60),
            image1.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            image1.widthAnchor.constraint(equalToConstant: 188),
            image1.heightAnchor.constraint(equalToConstant: 191),
            
            image2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 149),
            image2.topAnchor.constraint(equalTo: view.topAnchor, constant: 336),
            image2.widthAnchor.constraint(equalToConstant: 123),
            image2.heightAnchor.constraint(equalToConstant: 89),
            
            image3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 13),
            image3.topAnchor.constraint(equalTo: view.topAnchor, constant: 222),
            image3.widthAnchor.constraint(equalToConstant: 130),
            image3.heightAnchor.constraint(equalToConstant: 130),
            
            image4.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            image4.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            image4.widthAnchor.constraint(equalToConstant: 125),
            image4.heightAnchor.constraint(equalToConstant: 138),
            
            resetButton.topAnchor.constraint(equalTo: view.topAnchor , constant: 20),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 20 ),
            resetButton.widthAnchor.constraint(equalToConstant: 300),
            resetButton.heightAnchor.constraint(equalToConstant: 138),
            
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
    
    @objc func reset(){
        let today = Date().toDateString()
        let modalShownKey = "modalShown_\(today)"
        
        // 알림 메시지 생성
        let alert = UIAlertController(title: "확인",
                                      message: "오늘 할일 상태 초기화하시겠습니까?",
                                      preferredStyle: .alert)
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "초기화", style: .destructive) { _ in
            // UserDefaults 값 삭제
            UserDefaults.standard.removeObject(forKey: modalShownKey)
            print("모달 상태 초기화됨")
            
        }
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("초기화 취소됨")
        }
        
        // 알림에 액션 추가
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        // 알림 표시
        if let currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            currentViewController.present(alert, animated: true, completion: nil)
        }
    }
}
//MARK: - tableview Extension

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
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
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let taskItem = self.taskData[indexPath.row]
            guard let userId = self.userId else { return }
            var endpoint: String
            
            // 디버깅 로그
            print("🟢 삭제 요청 시작")
            print("📍 IndexPath: \(indexPath.row)")
            print("📦 삭제할 데이터: \(taskItem)")
            
            // 네트워크 엔드포인트 설정
            switch taskItem.type {
            case .detail:
                if let detail = taskItem.task as? Detail {
                    endpoint = "/plansubdetail/\(userId)/\(detail.detailId)"
                } else { return }
            case .plan:
                if let plan = taskItem.task as? Plan {
                    endpoint = "/plan/\(userId)/\(plan.planId)"
                } else { return }
            }
            
            // API 삭제 요청
            self.apiService.delete(endpoint: endpoint) { (result: Result<EmptyResponse, Error>) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.taskData.remove(at: indexPath.row)
                        
                        
                        
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.endUpdates()
                        
                        print("✅ 삭제 성공")
                        print("📦 남은 데이터: \(self.taskData)")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        
                        print("❌ 삭제 실패: \(error.localizedDescription)")
                        
                    }
                }
            }
            completion(true)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9986872077, green: 0.3591775596, blue: 0.006945624482, alpha: 1)
        deleteAction.title = "삭제"
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
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
                    
                    let modalShownKey = "modalShown_\(today)"
                    let hasModalBeenShown = UserDefaults.standard.bool(forKey: modalShownKey)
                    
                    
                    // 일정이 있고 모두 완료되었을 때만 모달 표시
                    if schedule.totalCount > 0 &&
                        schedule.totalCount == schedule.completedCount && !hasModalBeenShown {
                        // 모달 표시
                        let modalVC = completemodalController()
                        modalVC.modalPresentationStyle = .overFullScreen
                        modalVC.modalTransitionStyle = .crossDissolve
                        self?.present(modalVC, animated: true)
                        UserDefaults.standard.set(true, forKey: modalShownKey)
                        
                    }
                    
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
        
        taskData.removeAll()
        
        guard let schedule = dailySchedule else { return }
        
        
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
    
    //MARK: - patch
    func sendToggledTasks() {
        guard !toggledPlanIds.isEmpty || !toggledDetailIds.isEmpty,
              let userId = userId else {
            print("❌ 전송 취소: toggledPlanIds와 toggledDetailIds가 모두 비어있거나 userId가 없습니다.")
            return
        }
        
        print("\n🔍 토글 데이터 확인 ===============")
        print("👤 userId: \(userId)")
        print("📅 토글된 Plan IDs: \(toggledPlanIds)")
        print("📝 토글된 Detail IDs: \(toggledDetailIds)")
        
        let completedTasks = CompletedTasks(
            planIds: Array(toggledPlanIds),
            planSubDetailIds: Array(toggledDetailIds)
        )
        
        let today = Date().toDateString()
        let endpoint = "/toggle/\(userId)/\(today)"
        
        print("\n📡 요청 정보 ===============")
        print("🔗 엔드포인트: \(endpoint)")
        print("📅 날짜: \(today)")
        
        do {
            let jsonData = try JSONEncoder().encode(completedTasks)
            
            // JSON 데이터 출력
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("\n📦 전송될 JSON 데이터:")
                print(jsonString)
            }
            
            guard let parameters = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                print("❌ JSON 변환 실패")
                return
            }
            
            print("\n🔄 변환된 파라미터:")
            print(parameters)
            
            apiService.patch(endpoint: endpoint, parameters: parameters) { [weak self] (result: Result<APIResponse, Error>) in
                switch result {
                case .success(let response):
                    print("\n✅ 토글 상태 전송 성공")
                    print("응답: \(response)")
                    self?.toggledPlanIds.removeAll()
                    self?.toggledDetailIds.removeAll()
                    print("🧹 토글 ID 초기화 완료")
                    
                case .failure(let error):
                    print("\n❌ 토글 상태 전송 실패")
                    print("에러: \(error.localizedDescription)")
                }
                print("===============================\n")
            }
        } catch {
            print("\n❌ JSON 인코딩 실패")
            print("에러: \(error)")
            print("===============================\n")
        }
    }
    
    
}



extension MainViewController: MainTableViewCellDelegate {
    func didToggleCheckbox(for task: Any, isSelected: Bool) {
        switch task {
        case let plan as Plan:
            if isSelected {
                toggledPlanIds.insert(plan.planId)
            } else {
                toggledPlanIds.insert(plan.planId)
            }
            
        case let detail as Detail:
            if isSelected {
                toggledDetailIds.insert(detail.detailId)
            } else {
                toggledDetailIds.insert(detail.detailId)
            }
            
        default:
            break
        }
        
    }
    
    
}
