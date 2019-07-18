#!/usr/bin/env ruby
# Author : Emad Elsaid (https://github.com/blazeeboy)
require 'sinatra'
 
set :port, 80
set :environment, :production
 
get '/' do
	<<-EOT
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<!--<link rel="stylesheet" href="style.css">-->
		<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>-->
		<!--[if IE]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	</head>
	<body>
		<header>
			<nav></nav>
		</header>

	<form action="/" method="post" enctype="multipart/form-data" >
		Choose files <input type="file" name="files[]" multiple>
		<input type="submit" value="Upload" />
	</form>
		<footer></footer>
	</body>
</html>
EOT
end

post '/' do
	params['files'].each do |f|
		tempfile = f[:tempfile]
		filename = f[:filename]
		FileUtils.copy(tempfile.path, "./#{filename}")
	end
	redirect '/'
end
