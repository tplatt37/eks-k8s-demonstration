const express = require('express')
const app = express()
const port = 3000
var os = require("os");
const hostname = os.hostname;

const semver = "v3.0.9";
const style = "body {color: blue; background-color: orange;}";

// This will accept any URL / Path / Query String
app.get('*', (req, res) => {
  
  const time_up = process.uptime();
  const path = req.path;
   
  // Simulate a Readiness checker.
  // Container is not "Ready" (to serve traffic) until after 60 seconds of uptime
  if ( path === "/ready" && time_up < 60.0 )
  {
    // Readiness probe should return a 503 , by convention.
    res.sendStatus(503);
    console.log(`Process not ready yet! I need 60 seconds to warm up.`)
  }
  else
  {
    var timestamp = new Date().getTime();
    res.send(`<head><style>${style}</style></head><body><h1>Hello World! ${semver}</h1><br />(from ${hostname} at ${timestamp})<br />req.url=${JSON.stringify(req.url)}</body>`)
  }

  console.log(`Request received at ${timestamp}.`)
  console.log(`req.url=${path}`)
  console.log(`process.uptime()=${time_up} seconds`)
  
})

// Graceful shutdown requested
// Best practice in Containers is to handle SIGTERM and not ignore it. 
// (If you ignore it you're going to get a SIGKILL 30 seconds later in k8s)
process.on('SIGTERM', () => {
  console.info('SIGTERM signal received. Commencing clean shutdown...');
  process.exit(0);
});

app.listen(port, () => {
  
  // Set this ENV VAR to 1 to simulate an app failure (which should have exit code 1 per k8s standard)
  if ( process.env.FAIL_ON_PURPOSE == "1")
  {
    console.log('FATAL ERROR: (Simulated) in the application code... exiting... (${hostname})')
    process.exit(1)
  }

  console.log(`Example app ${hostname} listening at http://localhost:${port}`)
})