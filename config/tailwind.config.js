const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    'bg-neutral', 'text-base-content',
    'bg-primary', 'text-primary-content',
    'bg-secondary', 'text-secondary-content',
    'bg-accent', 'text-accent-content',
    'bg-success', 'text-success-content',
    'bg-info', 'text-info-content',
    'bg-warning', 'text-warning-content',
    'bg-error', 'text-error-content'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
    require("daisyui"),
  ],
  daisyui: {
    themes: ['night'],
    darkTheme: false,
  },
}
