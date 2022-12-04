//
//  ShopView.swift
//  SeSAC_StudyMatcingApp
//
//  Created by J on 2022/11/30.
//

import UIKit

import RxSwift

class ShopView: BaseView {
    
    let disposeBag = DisposeBag()
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.contentMode = .scaleToFill
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let saveButton: CommonButton = {
        let view = CommonButton()
        view.selectedStyle()
        view.setTitle("저장하기", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureUI() {
        [backgroundImageView, sesacImageView, saveButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(172)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).offset(10)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-5)
            make.width.equalTo(sesacImageView.snp.height)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(12)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    func bindImageView(output: ShopViewModel.Output) {
        output.myInfo
            .withUnretained(self)
            .subscribe { vc, result in
                vc.backgroundImageView.image = .sesacBackgroundImage(num: result.background)
                vc.sesacImageView.image = .sesacImage(num: result.sesac)
            }
            .disposed(by: disposeBag)
        
        output.infoFailed
            .asDriver()
            .drive (onNext: { [weak self] error in
                guard let self = self else {return}
                if error == true {
                    self.makeToast("사용자의 정보를 불러오는데 실패했습니다.")
                }
            }).disposed(by: disposeBag)
            
    }
}
