require "./money"
require "./card"
require "./deck"
require "./player"
require "./dealer"

class Blackjack
    def start
        @money = Money.new
        puts <<~"text"
        ----------------------------------
        |                                |
        |           BLACK JACK           |
        |                                |
        ----------------------------------
        所持金：#{@money.check}円からスタート！！
        text
        #moneyを維持したまま、ゲームをループさせる
        game_loop = true
        while game_loop
            #トランプデッキを生成する
            deck = Deck.new
            player = Player.new
            dealer = Dealer.new
            #所持金の確認
            puts <<~text
    
            現在の所持金は#{@money.check}円です。
            掛け金を入力して下さい。
    
            text
            #ベットが正常に行われるまでループするためのフラグ
            bet_pass = false
            while !bet_pass
                #ベット金額を入力
                @bet = gets.chomp.to_i
                if @bet.between?(1,@money.check)
                    #掛け金入力後の表示(所持金内の入力)
                    puts <<~text
        
                    ----------------------------------
                    掛け金：#{@bet}円
                    残金：#{@money.check(@bet)}円
                    ----------------------------------
        
                    text
                    #ベット完了したらループを抜ける
                    bet_pass = true
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
            player.first_draw(deck)
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
            dealer.first_draw(deck)
            #dealerのポイントを計算する
            @dealer_point = dealer.point_dealer
    
            #プレイヤーの行動を制御
            action_pass = false
            #プレイヤーがバストした際はディーラーはカードを引かない為のフラグ
            @dealer_though = false
            while !action_pass
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
                        @dealer_though = true
                        action_pass = true
                    end
                elsif action == 2
                    action_pass = true
                else
                    puts <<~text
                    ----------------------------------
                    エラー：選択肢1または2をお選び下さい。
                    ----------------------------------
                    text
                end
            end
            @player_win = false
            #バストしていなければ以下の処理を行う
            if !@dealer_though
                #@dealer_pointが16以下ならカードを引く
                while @dealer_point <= 16
                    dealer.draw_dealer(deck)
                    @dealer_point = dealer.point_dealer
                end
                #ディーラーがバストした場合の処理
                if @dealer_point >= 22
                    bust('player')
                    @player_win = true
                else
                    puts <<~text
                    ----------------------------------
                    ディーラーがカードを引き終わりました。
                    結果判定に参りましょう！
                    ----------------------------------
                    text
                end
            end
            judgement(@player_point, @dealer_point, @bet, @dealer_though,@player_win)
            if @money.check <= 0
                puts <<~text
                
                ----------------------------------
                所持金が無くなりました。
                ゲームオーバーです。
                ----------------------------------
    
                text
                game_loop = false
            end
            puts <<~text
            ----------------------------------
            ゲームを続行しますか？
            1.続行する　2.終了する
            ----------------------------------
            text
            #正しい入力があるまでループする
            game_end_pass = false
            while !game_end_pass
                game_end = gets.chomp.to_i
                if game_end == 2
                    game_loop = false
                    game_end_pass = true
                elsif game_end == 1
                    game_end_pass = true
                else
                    puts <<~text
                    ----------------------------------
                    エラー：選択肢1または2をお選び下さい。
                    ----------------------------------
                    text
                end
            end
        end
    end

    def bust(winner)
        puts <<~text
        ----------------------------------
        バストしました。#{winner}の勝ちです。
        ----------------------------------
        text
    end

    def judgement(player,dealer,bet,dealer_though,player_win)
        puts <<~text

        ----------------------------------
        ディーラーの手札の合計：#{dealer}
        ----------------------------------
        
        text
        #プレイヤーがディーラーより数値が大きいかつプレイヤーがバストしていない
        #または、ディーラーがバストしている状態
        if player > dealer && !dealer_though || player_win
            puts "あなたの勝ちです！"
            @money.reword(bet)
        elsif player == dealer
            puts "引き分けです。"
            @money.back(bet)
        else
            puts "あなたの負けです"
        end
    end
end