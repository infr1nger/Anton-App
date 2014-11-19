# coding: utf-8
require "rubygems"
require "oj"
require "hashie"
require "greeb"

class GreebController < ApplicationController
    def index
       @f = 'Some Text'
       @text = 'С тех пор, как Риту жестоко убили, Картер сидит у окна. Никакого телевизора, чтения, переписки. Его жизнь — то, что видно через занавески. Ему плевать, кто приносит еду, платит по счетам, он не покидает комнаты. Его жизнь — пробегающие физкультурники, смена времен года, проезжающие автомобили, призрак Риты.
Картер не понимает, что в обитых войлоком палатах нет окон.'
    @tokens = Greeb::Tokenizer.tokenize(@text)
    end 

    def process_text
        
    end
    
end
