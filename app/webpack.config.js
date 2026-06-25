const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const appDirectory = __dirname;

const babelLoaderConfig = {
  test: /\.(js|jsx|ts|tsx)$/,
  exclude: /node_modules\/(?!(react-native-web|react-native-gesture-handler|react-native-reanimated|@react-navigation|react-native-screens|react-native-safe-area-context)\/).*/,
  use: {
    loader: 'babel-loader',
    options: {
      presets: [
        '@babel/preset-env',
        '@babel/preset-react',
        '@babel/preset-typescript',
      ],
      plugins: [
        'react-native-web',
      ],
    },
  },
};

module.exports = {
  entry: path.join(appDirectory, 'index.web.js'),
  output: {
    path: path.join(appDirectory, 'web-dist'),
    filename: 'bundle.js',
  },
  resolve: {
    extensions: ['.web.tsx', '.web.ts', '.web.js', '.tsx', '.ts', '.js'],
    alias: {
      'react-native$': 'react-native-web',
      'react-native-video': path.join(appDirectory, 'src/web/VideoPlayerStub'),
    },
  },
  module: {
    rules: [babelLoaderConfig],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(appDirectory, 'public/index.html'),
    }),
  ],
  devServer: {
    port: 3000,
    hot: true,
  },
};
