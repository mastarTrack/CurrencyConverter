# Currency Converter App 📈

> 실시간 환율 Open API를 활용하여 환율 정보를 조회하고  
> 금액 변환 및 즐겨찾기 기능을 제공하는 iOS 앱

---

<img width="400" height="1100" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 05 33" src="https://github.com/user-attachments/assets/668d7de3-1f7f-4b0d-8b32-72ed7854610b" />

<img width="400" height="1100" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 06 17" src="https://github.com/user-attachments/assets/016bb5f8-534e-4fc8-8312-3c8c6cbf28f1" />

<img width="400" height="1100" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 11 06 02" src="https://github.com/user-attachments/assets/bd9bb4ba-85b9-4742-9261-9a7784ac9bfb" />

<img width="400" height="1100" alt="4DB73475-E5A9-4057-B18A-5A0130CDCD44" src="https://github.com/user-attachments/assets/15783e1c-006c-4bbf-af2e-b720ff4e9a4a" />



## 📱 프로젝트 소개

환율 정보는 실시간으로 변동되며 다양한 국가 통화가 존재합니다.  
본 프로젝트는 Open API를 통해 환율 데이터를 받아와 리스트로 표시하고,  
사용자가 원하는 통화를 즐겨찾기하여 상단에 고정할 수 있도록 구현한 앱입니다.

---

## 🛠 Tech Stack

- **UIKit**
- **SnapKit**
- **Alamofire**
- **MVVM Architecture**
- **CoreData**
- **UITableView**

---

## 🧱 Architecture

본 프로젝트는 **MVVM 패턴**을 기반으로 설계되었습니다.
```
📦 currencyConverter
┣ 📂 ViewController
┃ ┣ ExchangeRateViewController.swift
┃ ┣ CalculatorViewController.swift
┣ 📂 View
┃ ┣ MainView.swift
┃ ┣ CalculatorView.swift
┃ ┗ ExchangeRateTableViewCell.swift
┣ 📂 ViewModel
┃ ┣ ExchangeRateViewModel.swift
┃ ┣ CalculatorViewModel.swift
┃ ┗ ViewModelProtocol.swift
┣ 📂 Model
┃ ┣ ExchangeRate.swift
┃ ┗ countryDictionary.swift
┣ 📂 Manager
┃ ┣ NetworkManager.swift
┃ ┗ CoreDataManager.swift
┗ SceneDelegate.swift
```
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

### 🌙 야간 모드 (Dark Mode) 지원

- 시스템 Appearance(Light/Dark)에 따라 자동으로 UI가 전환되도록 구현
- 색상 Asset을 활용하여 배경색, 텍스트 색상등이 자연스럽게 변경되도록 설계
- 다크 모드 환경에서도 가독성과 사용자 경험을 유지하도록 UI 대비를 고려

---

## 🌐 Data Flow

### 환율 데이터 요청 흐름

```
ExchangeRateViewModel
↓
NetworkManager.fetchRates()
↓
Alamofire
↓
JSON Response
↓
Model Decoding
↓
View Update
```

---

### 즐겨찾기 저장 흐름

```
사용자 버튼 클릭
↓
클로저 전달
↓
ViewModel 처리
↓
CoreDataManager
↓
CoreData 저장
↓
정렬 후 UI 갱신
```
---

## 🔍 Instruments를 활용한 메모리 누수 점검
- 앱의 안정성을 확보하기 위해 **Xcode Instruments**의 Leaks instruments를 사용하여 메모리 누수 테스트를 진행함

<img width="800" height="400" alt="스크린샷 2026-02-25 오후 7 21 14" src="https://github.com/user-attachments/assets/39f23761-431b-4baa-a639-2b7ba8ea6e23" />

### 테스트 결과
- ❌ Memory Leak 미발견
- Leak Count: **0**
- Leak Checks 전 구간에서 정상(초록 체크 표시)


## 📦 DebugSwift를 활용한 메모리 누수 점검
- 앱의 안정성을 확보하기 위해 **DebugSwift** Package를 활용하여 런타임 환경에서 메모리 누수 여부를 점검함
<img width="600" height="1800" alt="FFDFBA2A-75EC-40D4-A05D-A35410F6D69F" src="https://github.com/user-attachments/assets/00d44a35-e968-488f-b8c5-37f47f445f04" />


### 테스트 결과
- ❌ Memory Leak 미발견
- Leak Count: **0**
- 반복 동작 이후에도 메모리 증가 현상 없음

---
