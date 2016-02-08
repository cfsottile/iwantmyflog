Bundler.require

def posts_ids_at_url(url)
	doc = Nokogiri::HTML(`curl -s #{url}`)
	doc.css("#list_photos_mosaic").children.map do |square|
		square.children.first["href"].split("/").last
	end
end

def valid_url?(url)
	`curl -s -o /dev/null -w "%{http_code}" #{url}` == "200"
end

def get_posts_ids
	base_url = "http://www.fotolog.com/#{$username}/mosaic/"
	posts_ids = []
	page = 0
	loop do
		posts_ids.concat(posts_ids_at_url(base_url + (page * 30).to_s + "/"))
		page += 1
		if !valid_url?(base_url + (page * 30).to_s + "/")
			break
		end
	end
	$posts_amount = posts_ids.size
	posts_ids
end

def download_post(post_id)
	post_dir = "#{$resources_dir}/#{post_id}"
	post_url = "www.fotolog.com/#{$username}/#{post_id}/"
	target_file = "#{post_dir}/www.fotolog.com/#{$username}/#{post_id}/index.html"

	create_dir(post_dir)
	
	commands = [
		"cd #{post_dir}",
		"wget -q -E -H -k -K -p -e robots=off #{post_url}"
	]
	system(commands.join("; "))
end

def create_dir(*dir)
	dir.each do |d|
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

def download_posts
	puts "Downloading..."
	puts "FYI:"
	puts "* This operation may (will) take a few minutes to start, do not get mad if it get stucked at 0.0% a while."
	puts "* Around 90%, it will take a few long minutes to finish. You will desperate, but trust me, it will end."
	print "\r0.0% complete"
	
	$start_time = Time.now.to_i
	posts_ids = get_posts_ids
	threads = []
	threads_amount = calculate_threads_amount(posts_ids)
	
	posts_ids.each_slice(threads_amount) do |posts|
		threads << Thread.new do
			posts.each do |post|
				download_post(post)
				create_post_link(post)
				update_percentage
			end
		end
	end

	threads.each {|t| t.join}
end

def calculate_threads_amount(posts_ids)
	max_threads = 50
	posts_ids.size > max_threads ? posts_ids.size / max_threads : 1
end

def update_percentage
	$mutex.synchronize do
		$downloaded_posts += 1
		print "\r#{format("%.2f", $downloaded_posts.to_f / $posts_amount * 100)}% complete"
		if $downloaded_posts == $posts_amount
			$end_time = Time.now.to_i
			# $total_time = Time.at($end_time - $start_time).strftime("%M:%S")
			$total_time = $end_time - $start_time
			puts "\nDownloaded #{$posts_amount} posts in #{$total_time} seconds"
		end
	end
end

$username = ARGV[0]
if $username.nil?
	puts "Usage: ./#{$0} your_fotolog_username"
	exit 1
end
$main_dir = "#{Time.now.to_i}-#{$username}"
$resources_dir = "#{$main_dir}/resources"
$posts_dir = "#{$main_dir}/posts"

$mutex = Mutex.new
$posts_amount
$downloaded_posts = 0

puts "Starting..."
create_dir($main_dir, $resources_dir, $posts_dir)
download_posts