var path = require('path');
var config = require('./config');
var { WebpackManifestPlugin } = require('webpack-manifest-plugin');

var webpackConfig = {
    mode: process.env.NODE_ENV,
    context: config.build.context,
    entry: {
        app: "./main.js",
    },
    output: {
        path: config.build.assetsPath,
        filename: 'js/[name].[chunkhash].js',
        publicPath: config.build.assetsURL
    },
    plugins: [
        // Write a manifest.json into instance/static/manifest.json so we know
        // that main.js corresponds to main-24321894670976bbbbbwuy.js
        new WebpackManifestPlugin({
            fileName: 'manifest.json',
            stripSrc: true,
            publicPath: config.build.assetsURL
        })
    ],
    resolve: {
        extensions: ["*", ".js", ".jsx"],
        // Needed to deal with symlinks between instane/assets/* and the source
        // files - so that when you edit, it can live reload.
        symlinks: false,
    }
}

module.exports = webpackConfig;
