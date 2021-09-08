<?php
	/*------
	## get status code of each link    : curl -q --head https://hotpotcookie.github.io/index.html | grep "HTTP" | cut -d ' ' -f 2
	## get potential directory to file : curl https://hotpotcookie.github.io | grep "href=" | cut -d '"' -f 2 | sort | uniq
	------*/
	$start = $argv[1];
	function crawl($url) {
		$options = array('http'=>array('method'=>"GET",'headers'=>"User-Agent: Crawler/0.1\n"));
		$context = stream_context_create($options);
		$doc = new DOMDocument();
		$port = ""; ## ":".parse_url($url)["port"]
		@$doc->loadHTML(file_get_contents($url,false,$context));

		$linkedlist = $doc->getElementsByTagName("a");
		foreach ($linkedlist as $link) {
			try {
				if (! empty(parse_url($url)["port"])) {
					$port = ":".parse_url($url)["port"];
				}				
			} catch(Exception $e) {$port = "";}
			$get_link = $link->getAttribute("href");

			if (substr($get_link,0,1) == "/" && substr($get_link,0,2) != "//") {
				$get_link = parse_url($url)["scheme"]."://".parse_url($url)["host"].$port.$get_link;
				echo "$get_link"."\n";				
			} else if (substr($get_link,0,2) == "./") {
				$get_link = parse_url($url)["scheme"]."://".parse_url($url)["host"].$port.dirname(parse_url($url)["path"]).substr($get_link,1);
				echo "$get_link"."\n";
			} else if (substr($get_link,0,1) == "#") {
				$get_link = parse_url($url)["scheme"]."://".parse_url($url)["host"].$port.parse_url($url)["path"].$get_link;
				echo "$get_link"."\n";
			} else if ((substr($get_link,0,5) != "https") && (substr($get_link,0,4) != "http") && (substr($get_link,0,6) != "mailto")) {
				$get_link = parse_url($url)["scheme"]."://".parse_url($url)["host"].$port.parse_url($url)["path"].$get_link;
				echo "$get_link"."\n";
			}			
		}
	}
	crawl($start);
?>
