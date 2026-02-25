# Currency Converter App 📈

> 실시간 환율 Open API를 활용하여 환율 정보를 조회하고  
> 금액 변환 및 즐겨찾기 기능을 제공하는 iOS 앱

---

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 05 33" src="https://github.com/user-attachments/assets/668d7de3-1f7f-4b0d-8b32-72ed7854610b" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 06 17" src="https://github.com/user-attachments/assets/016bb5f8-534e-4fc8-8312-3c8c6cbf28f1" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 06 02" src="https://github.com/user-attachments/assets/bd9bb4ba-85b9-4742-9261-9a7784ac9bfb" />


## 📱 프로젝트 소개

환율 정보는 실시간으로 변동되며 다양한 국가 통화가 존재합니다.  
본 프로젝트는 Open API를 통해 환율 데이터를 받아와 리스트로 표시하고,  
사용자가 원하는 통화를 즐겨찾기하여 상단에 고정할 수 있도록 구현한 앱입니다.

---

## 🛠 Tech Stack

- **UIKit**
- **SnapKit**
- **URLSession**
- **MVVM Architecture**
- **CoreData**
- **UITableView**

---

## 🧱 Architecture

본 프로젝트는 **MVVM 패턴**을 기반으로 설계되었습니다.

---

## ✨ 주요 기능

### ✅ 실시간 환율 조회
- Open API를 활용한 환율 데이터 수신
- JSON 디코딩 후 UITableView에 표시

---

### ✅ 금액 변환 기능
- 통화 선택 후 금액 입력
- 선택된 환율 기준으로 자동 계산
- 계산 로직을 ViewModel에서 처리하여 View와 분리

---

### ✅ 즐겨찾기 기능
- 관심 통화 즐겨찾기 등록
- CoreData에 저장
- 앱 재실행 시 유지
- 즐겨찾기 통화 상단 고정 정렬

---

### ✅ SnapKit 기반 UI 구성
- 코드 기반 AutoLayout
- Constraint 충돌 디버깅 경험
- Custom UITableViewCell 레이아웃 구성

---
