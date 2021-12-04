<?php

$_GET['q'] = 'test'; // example query phrase

$q = trim($_GET['q']);

$index = 'index_documents';

require("sphinxapi.php");

$cl = new SphinxClient();
$q = $cl->EscapeString($q);
$cl->SetServer('localhost', 9812);
$cl->SetSelect("*, SNIPPET(content, '$q', 'limit=60', 'around=3') AS snippet");
$res = $cl->query($q, $index);

exit(json_encode($res, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
