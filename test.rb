#encoding: utf-8
require "rubygems"
require "hashie"
require "oj"
require "greeb"


text = 'С тех пор, как Риту жестоко убили, Картер сидит у окна. Никакого телевизора, чтения, переписки. Его жизнь — то, что видно через занавески. Ему плевать, кто приносит еду, платит по счетам, он не покидает комнаты. Его жизнь — пробегающие физкультурники, смена времен года, проезжающие автомобили, призрак Риты.
Картер не понимает, что в обитых войлоком палатах нет окон.'
text2 = 'Hello! I am 18! My favourite number is 133.7...'
tokens = Greeb::Tokenizer.tokenize(text)
sent = Greeb::Segmentator.new(tokens).sentences

tokens.each do |t|
    if t.type == :letter
     from = t.from
     to = t.to - 1
     puts text[from..to]
    end 
end 

puts text
puts sent.size







