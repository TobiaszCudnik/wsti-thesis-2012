ROOT=`dirname $0`
$ROOT/../node_modules/.bin/mocha $ROOT/../test/graph.coffee -r should
