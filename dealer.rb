require "./gamer"

class Dealer < Gamer

    def first_draw(deck)
        # 生成したdeckからdrawメソッドを用いてカードを一枚引いてくる
        card = deck.draw
        # 引いたカードを手札に追加する
        @hands << card
        puts <<~text
        ------------Dealer手札------------
        1枚目 ： #{card.show}
        2枚目 ： 伏せられている
        ----------------------------------
        text
        # 初回は2回なので再度繰り返す
        card = deck.draw
        @hands << card
    end

    # dealerの点数を表示
    def point_dealer
        # 点数の初期化
        dealer_point = 0
        # 手札のカードを一枚ずつ確認して点数を計算していく
        @hands.each do |draw_card|
            # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
            dealer_point += draw_card.point
            #puts player_point
        end
        dealer_point
    end

end