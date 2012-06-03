<?php
require_once "HTTP/Request.php";

$apiBase = 'http://rosettacode.org/mw/api.php?';
$queryRevisions = 
  array(
	'action' => 'query',
	'prop' => 'revisions',
	'rvprop' => 'content',
	'rvlimit' => '1',
	'rvdir' => 'older',
	'generator' => 'search',
	'gsrsearch' => 'Apply a callback to an array',
	'gsrlimit' => '1',
	'rvexpandtemplates' => '1',
	//	'rvparse' => '1',
	'format' => 'json'
	);

$queryCats =
  array(
	'action' => 'query',
	'list' => 'categorymembers',
	'cmtitle' => 'Category:Ada',
	'cmlimit' => '100',
	'format' => 'json'
	);

function makeRequest($base, $params, $localStore) {
  $request =& new HTTP_Request($base);
  $request->setMethod(HTTP_REQUEST_METHOD_GET);
  foreach ($params as $name => $value) {
    $request->addQueryString($name, $value);
  }

  if (PEAR::isError($request->sendRequest())) {
    $response = "Request was malformed!";
  } else {
    $response = $request->getResponseBody();
  }

  file_put_contents($localStore, $response);
}


makeRequest($apiBase, $queryRevisions, 'localRev.json');

?>