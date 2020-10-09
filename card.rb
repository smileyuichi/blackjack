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