# CurrencyConverter (전세계 환율 정보 안내 및 계산 애플리케이션(USD)) (iOS)

Swift로 개발한 **전세계 환율 정보 안내 및 계산 애플리케이션**입니다.  
OpenApi를 통한 기준통화 대비 전세계 환율 정보를 리스트 형식으로 제공하며, 선택한 국가 통화를 기준통화기준 계산해주는 어플리케이션입니다.

---

## 🧾 프로젝트 소개
  
iOS UIKit 기반으로 UI 및 플로우를 설계·구현하며  
**MVVM 구조**, **CoreData**, **네트워크 연결(API)** 학습하기 위한 프로젝트입니다.  

---

## 🛠 기술 스택

- **Language**: Swift  
- **UI Framework**: UIKit  
- **Architecture**: MVVM
- **Data Source**: OpenAPI(“https://open.er-api.com/v6/latest/USD”)
- Package
  - **Layout**: SnapKit
  - **Network**: Alamofire
  - **Utility**: Then

---

## 📁 프로젝트 구조
``` currencyConverter
├── CoreData
│ ├── UpdateUnix+CoreDataClass.swift
│ ├── UpdateUnix+CoreDataProperties.swift
│ ├── WorldCurrency+CoreDataClass.swift
│ ├── WorldCurrency+CoreDataProperties.swift
│ ├── LastPage+CoreDataClass.swift
│ └── LastPage+CoreDataProperties.swift
│
├── Model
│ ├── CurrencyCoreDataManager.swift
│ ├── WorldCurrencyManager.swift
│ └── WorldCurrencyModel.swift
│
├── Service
│ ├── APIService.swift
│ └── CommonUtils.swift
│
├── View
│ └── CurrencyCell.swift
│
├── ViewController
│ ├── Base
│ │ ├── BaseViewController.swift
│ │ └── BaseViewModelProtocol.swift
│ │
│ ├── CurrencyCalculatorViewController.swift
│ └── WorldCurrencyViewController.swift
│
└── ViewModel
└── WorldCurrencyViewModel.swift
```

## 📦 구조 설명

### 📁 CoreData
CoreData Entity 
- UpdateUnix: 환율 업데이트 시간 저장
- WorldCurrency: 통화 정보 저장
- LastPage: 마지막 페이지 상태 저장

---

### 📁 Model
- CurrencyCoreDataManager: CoreData CRUD 관리
- WorldCurrencyManager: 환율 데이터 관리
- WorldCurrencyModel: 통화 데이터 모델

---

### 📁 Service
- APIService: 환율 API 통신
- CommonUtils: 공통 유틸 함수

---

### 📁 View
- CurrencyCell: 통화 표시 UICollectionViewCell

---

### 📁 ViewController
#### Base
- BaseViewController: 공통 ViewController
- BaseViewModelProtocol: 공통 ViewModel 프로토콜
#### Screens
- CurrencyCalculatorViewController: 환율 계산 화면
- WorldCurrencyViewController: 통화 목록 화면

---

### 📁 ViewModel
- WorldCurrencyViewModel: 통화 ViewModel

---

## 🔄 데이터 흐름

1. 앱 실행  
2. CoreData 로드
3. 환율 정보 표출
  - 저장된 세계통화 CoreData, 및 다음 업데이트 시간 CoreData 존재 시 로드, 없을 시 API 호출 및 데이터 수집
  - 현재시간 기준 다음업데이트 시간 비교하여 현재시간이 더 빠를시, Api를 통한 업데이트 내용 수집
  - 이전 환율 대비 업데이트 환율의 차이에 따른 변동 사항 저장 및 표기(UP/DOWN)
4. 마지막 저장 기록 확인
  - 마지막으로 기록한 화면 정보 CoreData를 읽기, 데이터 존재 시 마지막 화면으로 전환
5. 환율 리스트에서 별모양(즐겨찾기) 선택 시, CoreData에 기록 및 리스트 최상단 배치
6. 리스트 선택 시, 선택한 환율을 계산할 수 있는 페이지 이동

---

## ✨ 주요 기능

- **MVVM 설계**
- **Rest API 연결**
- **CoreData를 이용한 로컬 데이터 CRUD**
- **CollectionView: compositional layout 사용**
- **앱상태를 저장하여 애플리케이션 재실행시, 마지막 화면 표출**
- **Timer를 이용한 환율 업데이트 기능 구현**

---

## 👤 Author: 한주헌
iOS Developer (Swift)

---

## ✨ 메모리 누수 체크
메모리 누수 이상 없음
<img width="1759" height="1002" alt="스크린샷 2026-02-25 오후 7 21 57" src="https://github.com/user-attachments/assets/21651421-f131-4685-9c93-df10f3642f0d" />
<img width="365" height="749" alt="스크린샷 2026-02-25 오후 8 07 28" src="https://github.com/user-attachments/assets/66bec756-f2db-4308-bfd6-c86d4e465715" />


