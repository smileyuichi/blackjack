class Money
    #所持金を設定する
    def initialize
        @money = 100000
    end

    #残金の確認とベット入金
    def check(bet=0)
        @money -= bet
    end

    #勝った時の報酬(掛け金分)
    def reword(bet)
        @money += bet * 2
    end

    #引き分けた時の返金
    def back(bet)
        @money += bet
    end
end