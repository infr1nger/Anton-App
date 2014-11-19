# coding: utf-8
require "rubygems"
require "oj"
require "hashie"

class Link < Hashie::Dash
  property :id
  property :id1
  property :id2
  property :value
end

class Name < Hashie::Dash
  property :id
  property :first
  property :last
  property :ph
end


class GraphController < ApplicationController
  def index
    @names = []
    @links = []
    n = Oj.load(File.open('public/names.json', 'r'))
    m = Oj.load(File.open('public/links.json', 'r'))
    n.each do |i|
      @names.push(Name.new(i))
    end 
    m.each do |c|
      @links.push(Link.new(c))
    end 
  end
end


