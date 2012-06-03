<?php

$dataDir = 'data/';

function parseCategories($inFile, $outFile) {
  $response = file_get_contents($inFile);
  $response = json_decode($response);
  
  $cats = $response->query->categorymembers;
  $sink = fopen($outFile, 'w');
  foreach ($cats as $cat) {
    $i = $cat->title;
    fwrite($sink, $i . "\n");
  }
  fclose($sink);
}

function parseRevisions($inFile, $outPath) {
  echo "Parsing $inFile\n";
  // Begin: terrible-hack to handle Mediawiki's json tree. There must be a better way... but not before 11am!
  $loaded = file_get_contents($inFile);
  $response = json_decode($loaded);
  $pages = (array)$response->query->pages;
  $result = array_shift( $pages ); // this element in the JSON tree is a pageID, which changes, so we skip it here
  $result = (array)$result->revisions; 
  $result = (array)array_shift($result);
  $result = array_shift($result);
  // End: terrible-hack
  // at this point, $result is a dump of the page content, now we focus on the <lang /> tags.
  $result = preg_match_all('/\<lang\s*\w*\>.*?\<\/lang\>/s', $result, $results);
  foreach ($results[0] as $lang) {
    $result = preg_match('/\<lang\s*(\w*)\>(.*?)\<\/lang\>/s', $lang, $code);
    if ( sizeof($code) )
      if (! is_dir($outPath) ) {
	mkdir($outPath);
	echo $code[1] . "\n";
      }
    file_put_contents("$outPath/$code[1]", $code[2]); // write each bare language example to a file
  }
}

function parseAllRevisions($dataDir) {
  $files = scandir($dataDir);
  foreach ($files as $file) {
    $pathParts = pathinfo($file);
    if ($pathParts['extension'] == 'json') {
      parseRevisions($dataDir . $file, $dataDir . "parsed/" . $pathParts['filename']);
    }
  }
}

parseCategories('data/problems.json', 'data/problems.txt');
  parseAllRevisions($dataDir);
?>