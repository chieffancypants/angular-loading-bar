var path = require("path");
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  entry: {
    js: "./src/loading-bar.js",
    css: "./src/loading-bar.scss"
  },
  output: {
    path: path.resolve(__dirname, "build"),
    filename: "loading-bar.min.[name]",
    libraryTarget: "umd",
    library: "angular-loading-bar"
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loaders: [
          'ng-annotate-loader'
        ]
      },
      {
        test: /\.scss$/,
        use: [{
          loader: "css-loader", // translates CSS into CommonJS
          options: {
            modules: true,
            minimize: true
          }
        }, {
          loader: "sass-loader" // compiles Sass to CSS
        }]
      }
    ]
  },
  externals: "angular",
  devtool: "cheap-module-source-map",
  resolve: {
    modules: [
      "node_modules"
    ],
    extensions: [".js", ".scss"]
  },
  plugins: [
    new UglifyJSPlugin(
      {
        mangle: {
          except: ['module', 'exports', 'require']
        }
      }
    )
  ]
};
