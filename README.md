# Drive time to Hourly Rate Converter

Custom calculator to handle reimbursement of driving time at hourly rates.

Employees are reimbursed based on driving time, not mileage.  Their total
miles at a given hourly rate are converted into hours of their normal hourly
rate.

Uses CSS from [Foundation Essentials](http://foundation.zurb.com/)

## Setup / Development / Build

1. Make sure you have npm and elm installed
2. Clone repository
3. `npm install` to install build plumbing
4. Use `gulp` or `gulp watch` to compile and copy files to the dist directory.  
  - You will need to call `gulp` the first time you build the project.
  - These tasks automatically call `elm-init` which will download required elm packages.

## Development Notes & Resources

- [gulp-elm](https://www.npmjs.com/package/gulp-elm)
- [Example Gulp + Elm](https://gist.github.com/dennisreimann/cd8d45eefaba43199dcd)
- [Learn you an Elm](http://learnyouanelm.github.io/index.html)

## Ideas for Future

* Improve rounding in view::formatFloat
* validate int vs float inputs, currently resets to zero
* HTML5 local-storage for storing last values
* better distribution creation
