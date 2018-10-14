#!/usr/bin/env php
<?php

// Project namespace
namespace Spicy;

// load Composer autoload file
require_once __DIR__ . '/vendor/autoload.php';

echo __NAMESPACE__ . " shell\n";

$sh = new \Psy\Shell();

// Set project namespace in Repl
if (defined('__NAMESPACE__') && __NAMESPACE__ !== '') {
    $sh->addCode(sprintf("namespace %s;", __NAMESPACE__));
}

$sh->run();

// Termination message
echo "Bye!.\n";
