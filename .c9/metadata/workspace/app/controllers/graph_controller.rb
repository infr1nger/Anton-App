{"filter":false,"title":"graph_controller.rb","tooltip":"/app/controllers/graph_controller.rb","undoManager":{"mark":5,"position":5,"stack":[[{"group":"doc","deltas":[{"action":"removeLines","range":{"start":{"row":0,"column":0},"end":{"row":2,"column":0}},"nl":"\n","lines":["class GraphController < ApplicationController","end"]}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":0,"column":0},"end":{"row":0,"column":15}},"text":"# coding: utf-8"},{"action":"insertText","range":{"start":{"row":0,"column":15},"end":{"row":1,"column":0}},"text":"\n"},{"action":"insertLines","range":{"start":{"row":1,"column":0},"end":{"row":51,"column":0}},"lines":["require \"rubygems\"","require \"vkontakte_api\"","require \"oj\"","require \"hashie\"","","class Link < Hashie::Dash","  property :id","  property :id1","  property :id2","  property :value","end","","class Name < Hashie::Dash","  property :id","  property :first","  property :last","  property :ph","end","","VkontakteApi.configure do |config|","  config.app_id       = '3580989'      # ID приложения","  config.app_secret   = '1B3yGWgeTazayYdAL8wy' # защищенный ключ","  config.redirect_uri = 'http://api.vkontakte.ru/blank.html' #http://oauth.vk.com/blank.html","  config.faraday_options = {","ssl: {",":verify => false","},","}","end","","access_token = '3dad3652d71811da69f177711598e26e401f918c20580e1d74ebdff0e28997371668a7cd2750205f4a03c'","@vk = VkontakteApi::Client.new(access_token)","","","class GraphController < ApplicationController","  def index","    @names = []","    @links = []","    n = Oj.load(File.open('public/names.json', 'r'))","    m = Oj.load(File.open('public/links.json', 'r'))","    n.each do |i|","      @names.push(Name.new(i))","    end ","    m.each do |c|","      @links.push(Link.new(c))","    end ","  end","end","",""]}]}],[{"group":"doc","deltas":[{"action":"removeLines","range":{"start":{"row":20,"column":0},"end":{"row":33,"column":0}},"nl":"\n","lines":["VkontakteApi.configure do |config|","  config.app_id       = '3580989'      # ID приложения","  config.app_secret   = '1B3yGWgeTazayYdAL8wy' # защищенный ключ","  config.redirect_uri = 'http://api.vkontakte.ru/blank.html' #http://oauth.vk.com/blank.html","  config.faraday_options = {","ssl: {",":verify => false","},","}","end","","access_token = '3dad3652d71811da69f177711598e26e401f918c20580e1d74ebdff0e28997371668a7cd2750205f4a03c'","@vk = VkontakteApi::Client.new(access_token)"]}]}],[{"group":"doc","deltas":[{"action":"removeLines","range":{"start":{"row":19,"column":0},"end":{"row":20,"column":0}},"nl":"\n","lines":[""]}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":2,"column":0},"end":{"row":2,"column":23}},"text":"require \"vkontakte_api\""}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":1,"column":18},"end":{"row":2,"column":0}},"text":"\n"}]}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":27,"column":30},"end":{"row":27,"column":30},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1416076013879,"hash":"a4016abde28a7c86036c0e5504a0b44754655df7"}