module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
    './src/**/*.{html,js}',
    './node_modules/tw-elements/dist/js/*.js'
  ],
  plugins: [
    require('tw-elements/dist/plugin'),
  ],
  safelist: [],
  darkMode: "class"
}
