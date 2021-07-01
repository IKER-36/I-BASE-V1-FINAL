const rewire = require('rewire');
const defaults = rewire('react-scripts/scripts/build.js');
let config = defaults.__get__('config');

config.optimization.splitChunks = {
	cacheGroups: {
		default: false,
	},
};

config.optimization.runtimeChunk = false;
config.output.filename = 'static/js/[name].js';
config.plugins[5].options.filename = 'static/css/[name].css';
config.plugins[5].options.moduleFilename = () => 'static/css/main.css';
config.module.rules[1].oneOf[0].options.name = 'static/assets/[name].[ext]';
config.module.rules[1].oneOf[1].options.name = 'static/assets/[name].[ext]';
