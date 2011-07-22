
# Capistrano Payload

Capistrano plugin that delivers JSON-encoded deployment information via POST to the URL of your choice.

## Installation

    gem install capistrano-payload
    
## Usage

Add payload plugin into your deploy.rb file:

    require 'capistrano-payload'
    
Then configure URL:

    set :payload_url, "http://your.awesome.url.com/payload"

To test if it works type:

    cap payload:deploy
    
The best way to test out is to use http://www.postbin.org/.

## Options

- payload_url     &mdash; Primary URL where the data would be sent (required)
- payload_format  &mdash; Payload format. Must be one of :json (default), :form, :yaml, :xml
- payload_params  &mdash; Extra parameters to the request (api_key, etc.). *Note: extra parameters wont be added to the payload.*
- payload_message &mdash; Ask for deployment comment. (default: true)

## Payload structure

Plugin will sent JSON-encoded data via POST method.

Here is the sample payload:

    {
      "capistrano": {
        "version": "2.6.0",
        "application": "APP_NAME",
        "deployer": {
          "user": "sosedoff",
          "hostname": "localhost",
        }
        "timestamp": "2011-07-21 19:09:52 -0500",
        "message": "Release 1.0.0", 
        "source": {
          "branch": "master",
          "revision": "b18ffa822c16c028765800d0c4d22bfd5e4f3bf9",
          "repository": "git@github.com:repository.git"
        },
        "action": "deploy"
      },
      "payload_version": "0.2.0"
    }

That's it. Ready to roll.

## License

Copyright © 2011 Dan Sosedoff.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.