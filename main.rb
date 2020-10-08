class Money
    #所持金を設定する
    def initialize
        @money = 10000
    end

    #残金の確認とベット入金
    def check(bet=0)
        @money -= bet
    end
end

class Card
    #カードオブジェクトからマークと数字の実引数を受け取る
    def initialize(mark, number)
        @mark = mark
        @number = number
    end

    #カードのmarkとnumberを表示
    def show
        "#{@mark}の#{@number}"
    end

    #対象カードのポイントを返す
    def point
        if @number == "J" || @number == "Q" || @number == "K"
            10
        elsif @number == "A"
            0
        else
            #数字は文字列として格納しているので、数値に変換して返す
            @number.to_i
        end
    end
end

class Deck
    def initialize
        #デッキの生成
        @cards = []

        mark = ["スペード","クラブ","ダイヤ","ハート"]
        number = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]

        #マークと数字の組み合わせを1つずつ生成して@cardsに格納していく
        mark.each do |mark|
            number.each do |number|
                # markとnumberの組み合わせを一つずつcardクラスに渡し、それぞれのcardオブジェクトを生成する
                card = Card.new(mark, number)
                # 生成したcardを配列に格納していく
                @cards << card
            end
        end
        @cards.shuffle!
    end

    #カードを引く
    def draw
        #配列の先頭を抜き取る
        @cards.shift
    end
    # デバッグ用
    # def numberOfSheets
    #     p @cards.size
    # end
end

class Player
    def initialize
        @hands = []
    end

    #最初に2回デッキからカードを引く
    def first_draw_player(deck)
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
class Dealer
    def initialize
        @hands=[]
    end

    def first_draw_dealer(deck)
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
        
        #トランプデッキを生成する
        deck = Deck.new
        player = Player.new
        dealer = Dealer.new
        #所持金の確認
        puts <<~text

        現在の所持金は#{money.check}円です。
        掛け金を入力して下さい。

        text
        #ベットが正常に行われるまでループするためのフラグ
        bet_certification = false
        while !bet_certification
            #ベット金額を入力
            @bet = gets.chomp.to_i
            if @bet.between?(1,money.check)
                #掛け金入力後の表示(所持金内の入力)
                puts <<~text
    
                ----------------------------------
                掛け金：#{@bet}円
                残金：#{money.check(@bet)}円
                ----------------------------------
    
                text
                #ベット完了したらループを抜ける
                bet_certification = true
            else
                #掛け金入力後の表示(所持金以上またはエラー)
                puts <<~text
    
                ----------------------------------
                エラー：所持金以内の数値で入力してください
                ----------------------------------
    
                text
            end

        end
        # deckからカードを引く
        player.first_draw_player(deck)
        #playerのポイントを計算する
        @player_point = player.point_player
        if player.count_11 == 0
            puts <<~text
            ----------------------------------
            あなたの手札の合計点数は#{@player_point}です。
            ----------------------------------
            text
        else
            puts <<~text
            ----------------------------------
            あなたの手札の合計点数は#{@player_point}、もしくは#{@player_point-10}です。
            ----------------------------------
            text
        end
        dealer.first_draw_dealer(deck)
        #dealerのポイントを計算する
        @dealer_point = dealer.point_dealer

        #プレイヤーの行動を制御
        action_certification = false
        while !action_certification
            puts <<~text
            ----------------------------------
            プレイヤーの行動を選択して下さい。
            1.Hit 2.Stand
            ----------------------------------
            text
            action = gets.chomp.to_i
            #Hitを選択した場合
            if action == 1
                # deckから一枚カードを取る
                player.draw_player(deck)
                @player_point = player.point_player
                puts <<~text
                ----------------------------------
                あなたの手札の合計点数は#{@player_point}です。
                ----------------------------------
                text
                if @player_point >= 22
                    bust("dealer")
                    action_certification = true
                end
            elsif action == 2
                action_certification = true
            else
                puts <<~text
                ----------------------------------
                エラー：選択肢1または2をお選び下さい。
                ----------------------------------
                text
            end
        end
        #dealerが引く
    end

    def bust(winner)
        puts <<~text
        バストしました。#{winner}の勝ちです。
        text
    end
end

blackjack = Blackjack.new

blackjack.start