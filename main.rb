class Money
    #所持金を設定する
    def initialize
        @money = 10000
    end

    def check
        @money
    end
end


class Blackjack
    def start
        money = Money.new
        puts <<~"text"
        ----------------------------------
        |                                |
        |           BLACK JACK           |
        |                                |
        ----------------------------------
        所持金：#{money.check}からスタート！！
        text
        #moneyを維持したまま、ゲームをループさせる

        #所持金の確認
        puts <<~text
        現在の所持金は#{money.check}円です。
        掛け金を入力して下さい。
        text

        #掛け金入力後の表示(所持金内の入力)
        puts <<~text
        掛け金：#{}円
        残金：#{}円
        text
        #掛け金入力後の表示(所持金以上またはエラー)
        puts <<~text
        エラー：所持金以内の数値で入力してください
        text
    end
end

blackjack = Blackjack.new

blackjack.start