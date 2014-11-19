# coding: utf-8
require "rubygems"



class ShulteController < ApplicationController
  def index
  @random_numbers = []
  rnd = Random.new
  
  while @random_numbers.size < 25
      @random_numbers.push rnd.rand(1..25)
      @random_numbers = @random_numbers.uniq
  end
 
  end
end
  
  


