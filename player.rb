class Player
    def initialize
        @hands = []
    end

    #最初に2回デッキからカードを引く
    def first_draw(deck)
        card = deck.draw
        # 引いたカードを手札に追加する
        @hands << card
        # 初回は2回なので再度繰り返す
        card = deck.draw
        @hands << card
        puts ""
        puts "------------Player手札------------"
        @hands.each.with_index(1) do |hand, i|
            puts " #{i}枚目 ： #{hand.show}"
        end
        puts "---------------------------------"
    end

    def point_player
        # 点数の初期化
        player_point = 0
        count_a = 0
        @count_11 = 0
        # 手札のカードを一枚ずつ確認して点数を計算していく
        @hands.each do |draw_card|
            # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
            player_point += draw_card.point
            #Aを引いた場合
            if draw_card.point == 0
                count_a += 1
            end
        end
        #Aを引いた分だけ数値の吟味を行う
        count_a.times do |i|
            if player_point <= 10
                player_point += 11
                @count_11 += 1
            else
                player_point += 1
            end
        end
        return player_point
    end

    def count_11
        @count_11
    end

    def draw_player(deck)
        card = deck.draw
        # 引いたカードを手札に追加する
        @hands << card
        puts "------------Player手札------------"
        @hands.each.with_index(1) do |hand, i|
            puts " #{i}枚目 ： #{hand.show}"
        end
        puts "---------------------------------"
    end
end