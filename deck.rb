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
end