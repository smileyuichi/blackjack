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
        
        player.first_draw_player(deck)
        dealer.first_draw_dealer(deck)
    end
end

blackjack = Blackjack.new

blackjack.start