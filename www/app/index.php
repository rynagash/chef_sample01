<?php
$app = new Phalcon\Mvc\Micro();

$app->get('/', function() {
  echo "<h1>Welcome</h1>";
});

$app->handle();
