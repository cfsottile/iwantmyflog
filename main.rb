Bundler.require

def links_at_url(url)
	doc = Nokogiri::HTML(Curl.get(url).body_str)
	doc.css("#list_photos_mosaic").children.map do |square|
		square.children.first["href"].split("/").last
	end
end

def valid_url?(url)
	Curl.get(url).status == "200 OK"
end

def links_for_user(username)
	base_url = "http://www.fotolog.com/#{username}/mosaic/"
	links = []
	page = 0
	loop do
		links.concat(links_at_url(base_url + (page * 30).to_s + "/"))
		page += 1
		if !valid_url?(base_url + (page * 30).to_s + "/")
			break
		end
	end
	links
end

def download_post(username, post_id)
	post_dir = "#{$resources_dir}/#{post_id}"
	post_url = "www.fotolog.com/#{username}/#{post_id}/"
	target_file = "#{post_dir}/www.fotolog.com/#{username}/#{post_id}/index.html"

	create_dir(post_dir)
	
	p "Downloading #{username}/#{post_id}"
	
	commands = [
		"cd #{post_dir}",
		"wget -q -E -H -k -K -p -e robots=off #{post_url}"
	]
	system(commands.join("; "))
end

def create_dir(*dir)
	dir.each do |d|
		p "Creating directory #{d}"
		system("mkdir #{d}")
	end
end

def create_post_link(post_id)
	commands = [
		"cd #{$posts_dir}",
		"ln -s ../../#{path_for_post(post_id)} post_#{post_id}"
	]
	system(commands.join("; "))
end

def path_for_post(post_id)
	"#{$resources_dir}/#{post_id}/www.fotolog.com/#{$username}/#{post_id}/index.html"
end

$username = ARGV[0]
$main_dir = "#{Time.now.to_i}-#{$username}"
$resources_dir = "#{$main_dir}/resources"
$posts_dir = "#{$main_dir}/posts"

create_dir($main_dir, $resources_dir, $posts_dir)
links_for_user($username)
	.each {|l| download_post($username, l)}
	.each {|l| create_post_link(l)}

