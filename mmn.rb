
# coding: utf-8
require "rubygems"
require "vkontakte_api"
require "hashie"
require "oj"

# Класс интеракций
class PairInt	< Hashie::Dash
	property :id1, :required => true
	property :id2, :required => true
end

time_start = DateTime.now

#Название приложения: infriNger test app
#ID приложения: 3580989
#Защищенный ключ: 1B3yGWgeTazayYdAL8wy
# линк на запись на стене http://vk.com/wall5259_3820


# pry -r vkontakte_api
# VkontakteApi.app_id = '3580989'
# VkontakteApi.redirect_uri = 'http://oauth.vk.com/blank.html'
# VkontakteApi.authorization_url(type: :client, scope: [:friends, :messages, :offline, :photos, :audio, :video, :wall, :groups])

VkontakteApi.configure do |config|
	config.app_id       = '3580989'      # ID приложения
	config.app_secret   = '1B3yGWgeTazayYdAL8wy' # защищенный ключ
	config.redirect_uri = 'http://api.vkontakte.ru/blank.html' #http://oauth.vk.com/blank.html
	config.faraday_options = {
ssl: {
:verify => false
},
}
end

id = 695433
access_token = '303ec3eae57a6dae6489504b791e58208390e59d21a87fc33ffffbf21c1e8bff26d43c53199552f480d4a'
@vk = VkontakteApi::Client.new(access_token)
@owner_friends = @vk.friends.get(uid: id)
@owner_friends.push id

# Создает или заменяет старый json файл и записывает в него массив data
def json_write(json_path, data)
	puts 'Writing to file ' + json_path.to_s + ' ...'

	if File::exist?(json_path)
		File.delete(json_path)
		else
		file = File.new(json_path, 'w')
	end

	o = Oj.dump(data)

    File.open(json_path,"w") do |f|
    	f.write(o)
	end

	puts 'Done!'
end

def graph_ids
	def ids_get(c)
		@vk.groups.getMembers(gid: 'aa.never', count: 1000, offset: c*1000)
	end
	
	m = []
	graph_count = @vk.groups.getMembers(gid: 'aa.never', count: 1)[:count]
	a = 0
	while a <= (graph_count / 1000)
		m.push ids_get(a).users
		a = a + 1
	end
	m = m.flatten.uniq
	puts m.size
	json_write('source/never.json', m)
end

def get_interactions(num)
	graph = Oj.load(File.open('source/smmrussia_ids.json', 'r'))
	array = []
	current_id = graph[num]

	c = 0
	wall_count = @vk.wall.get(owner_id: current_id, count: 1, offset: 0)[0]
	if wall_count > 0
		while c <= (wall_count / 100)
			wall_list = @vk.wall.get(owner_id: current_id, count: 100, offset: c*100)
			wall_list.delete(wall_list[0])
			msg_date = Time.at(wall_list[0].date)
			if msg_date.year > 2012	
				wall_list.each do |wall_msg|
					if  graph.include?(wall_msg.from_id) == true and wall_msg.from_id != current_id
						array.push PairInt.new(:id1 => wall_msg.from_id, :id2 => current_id)
					end
					if  graph.include?(wall_msg.copy_owner_id) == true 
						array.push PairInt.new(:id1 => current_id, :id2 => wall_msg.copy_owner_id)
					end
					if wall_msg.likes[:count] > 0
						@vk.likes.getList(type: 'post', owner_id: wall_msg.to_id, item_id: wall_msg.id).users.each do |i|
							if graph.include?(i) == true and i != current_id
								array.push PairInt.new(:id1 => i, :id2 => current_id)
							end
						end
					end
					if wall_msg.comments[:count] > 0
						comment_list = @vk.wall.getComments(owner_id: wall_msg.to_id, post_id: wall_msg.id, need_likes: 1, count: 100)
						comment_list.delete(comment_list[0])
						comment_list.each do |g|
							if  graph.include?(g.from_id) == true and g.from_id != current_id
								array.push PairInt.new(:id1 => g.from_id, :id2 => current_id)
							end
							if g.likes[:count] > 0
								@vk.likes.getList(type: 'comment', owner_id: wall_msg.to_id, item_id: g.cid).users.each do |l|
									if graph.include?(l) == true and l != current_id
										array.push PairInt.new(:id1 => l, :id2 => current_id)
									end
								end
							end
						end
					end
				end
				c = c + 1
			else
				c = (wall_count / 100) + 1
			end
		end
	end

	c = 0
	photos_count = @vk.photos.getAll(owner_id: current_id, no_service_albums: 1, offset: 0, count: 1, extended: 1)[0]
	if photos_count > 0
		while c <= (photos_count / 100)
			photos_list = @vk.photos.getAll(owner_id: current_id, no_service_albums: 1, offset: c*100, count: 100, extended: 1)
			photos_list.delete(photos_list[0])
			ph_date = Time.at(photos_list[0].created)
			if ph_date.year > 2012
				photos_list.each do |i|
					if photos_list[0].likes[:count] > 0
						@vk.likes.getList(type: 'photo', owner_id: i.owner_id, item_id: i.pid).users.each do |l|
							if graph.include?(l) == true and l != current_id
								array.push PairInt.new(:id1 => l, :id2 => current_id)
							end
						end
					end
				end
				c = c + 1
			else
				c = (photos_count / 100) + 1
			end
		end
	end

	fr = @vk.friends.get(uid: current_id)
	graph.each do |t|
		if fr.include?(t)
			array.push PairInt.new(:id1 => t, :id2 => current_id)
			array.push PairInt.new(:id1 => current_id, :id2 => t)
		end
	end

	json_write('source/interactions/Int' + current_id.to_s + '.json', array)
	puts current_id
end

def get_interactions_group
	g = Oj.load(File.open('source/smmrussia_ids.json', 'r'))
	n = (g.size / 4)
	a = 0
	b = 0

	while a <= n
		if b < 10
			begin
				get_interactions(a)
			rescue
			end
			b = b +1
		else
			begin
				get_interactions(a)
			rescue
			end
			sleep(10)
			b = 0
		end
		File.open('mmn1_log.txt',"w") do |f|
		 	f.write(a)
		end
		a = a + 1
	end
end

graph_ids
















