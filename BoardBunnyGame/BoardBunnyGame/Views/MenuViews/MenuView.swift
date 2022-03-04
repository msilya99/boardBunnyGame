//
//  MenuView.swift
//  BoardBunnyGame
//
//  Created by Ilya Maslau on 23.02.22.
//

import SwiftUI

struct MenuView: View {

    // MARK: - variables

    @StateObject private var gameModel: GameModel = GameModel()
    @State private var isActive: Bool = false
    @State private var shouldShowRules: Bool = false
    @State private var settingTitle: String = "Настройки игры"

    // MARK: - gui

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    TopPurpleView(size: geometry.size)
                    VStack {
                        ZStack(alignment: .trailing) {
                            DateView(text: $settingTitle)
                            Button {
                                shouldShowRules = true
                            } label: {
                                Image(systemName: "info.circle").font(.title)
                                    .foregroundColor(BaseColors.sh.getColorByType(.baseLight))
                            }.padding()
                        }
                        .padding()
                        .sheet(isPresented: $shouldShowRules) {
                            RulesView()
                        }

                        Image("bunny")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: geometry.size.height / 4)
                        MenuFormView(gameModel: gameModel, isToogleOn: gameModel.isUsingCustomNames)
                            .frame(minWidth: geometry.size.width)

                        Spacer()
                        PrimaryButton(title: "Начать игру") {
                            gameModel.updateSelectedTopic()
                            isActive = true
                        }

                        NavigationLink(destination: CardContentView(gameModel: gameModel),
                                       isActive: $isActive) { }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .accentColor(ThemeColors.sh.getColorByType(.base))
        .environmentObject(gameModel)
    }
}

struct RulesView: View {
    var body: some View {
        Group {
            Text("""
    Правила просты:
    \nЕсть определенное количество игроков и один из них "ЗАЕЦ".
    \nИгроки, которые не "ЗАЕЦ", получают одинаковое слово из определенной тематики и должны описать его одним другим ассоциативным для них словом.
    \nИгрок, который "ЗАЕЦ" должен хитрить и извертываться, пытаясь подобрать слово похожее на ассоциации.
    \nВ конце раунда происходит голосование, чтобы определить кто же "ЗАЕЦ".
    \n"ЗАЕЦ" побеждает только если ему каким-то образом удалось всех одурачить, либо если он в момент своего хода точно угадает загаданное слово. В последнем случае "ЗАЕЦ" идет ва-банк.\nПример: "Я заец и слово Жопа".
    Если слово было не жопа, "ЗАЕЦ" проигрывает, а иначе выигрывает.
    \nЧтобы "ЗАЕЦ" не угадал слово следует называть не самые поверхностные ассоциации.
    """)
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                .font(.body)
        }
        Spacer()
    }
}
