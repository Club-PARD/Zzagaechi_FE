import UIKit


class SeperateDayListView : UIView {
    //MARK: - property
    var data: [String] = []
//    var data: [String] = ["레퍼런스 찾아보기","디자인 제작", "교수님께 피드백 받고 수정"]
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private let cellHeight: CGFloat = 45
    private let footerHeight: CGFloat = 10
    
    
    var messageLabel : UILabel = {
        let label = UILabel()
        label.text = "요일을 선택하고 세분화 목록을 여기로 드래그 하세요!"
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size:  12)
        return label
    }()
    
    
    let seperateListTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
        setUI()
        setTable()
        seperateListTableView.dropDelegate = self
        seperateListTableView.dragInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func updateUI(){
        // 데이터가 빈 값이면 label, 있으면 tableView
        if data.isEmpty{
            messageLabel.isHidden = false
            seperateListTableView.isHidden = true
        } else {
            messageLabel.isHidden = true
            seperateListTableView.isHidden = false
            updateTableViewHeight()  
        }
        
    }
    
    func setUI(){
        [messageLabel,seperateListTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        tableViewHeightConstraint = seperateListTableView.heightAnchor.constraint(equalToConstant: calculateTableViewHeight())
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            seperateListTableView.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            seperateListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            seperateListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            seperateListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
    
    private func calculateTableViewHeight() -> CGFloat {
        let totalCellHeight = CGFloat(data.count) * cellHeight
        let totalFooterHeight = CGFloat(max(0, data.count - 1)) * footerHeight
        return totalCellHeight + totalFooterHeight
    }
    
    // TableView 높이 업데이트 함수
    private func updateTableViewHeight() {
        tableViewHeightConstraint?.constant = calculateTableViewHeight()
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    func setTable(){
        seperateListTableView.delegate = self
        seperateListTableView.dataSource = self
        seperateListTableView.register(SeperateDayListTableViewCell.self, forCellReuseIdentifier: "SecondSectionCell")
    }
}

//MARK: - tableview extension
extension SeperateDayListView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSectionCell" , for: indexPath) as? SeperateDayListTableViewCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        cell.taskLabel.text = data[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 스와이프 스타일 설정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 삭제 액션 처리
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 데이터 소스에서 항목 삭제
            data.remove(at: indexPath.section)  // section을 사용하는 경우
            // 또는
            // data.remove(at: indexPath.row)  // row를 사용하는 경우
            
            // TableView 업데이트
            tableView.reloadData()
            
            // UI 업데이트가 필요한 경우
            updateUI()
        }
    }
    
    // 삭제 버튼 텍스트 커스텀
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    
    
}


extension SeperateDayListView: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        coordinator.items.forEach { dropItem in
            guard let sourceItem = dropItem.dragItem.localObject as? String else { return }
            
            // 드롭된 아이템을 데이터 배열에 추가
            data.insert(sourceItem, at: destinationIndexPath.section)
            
            // UI 업데이트
            updateUI()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
}
