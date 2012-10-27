# Cines API

An attempt at an open JSON API with movie showtimes for chilean movie theaters. Since none of the websites provide an API for this I thought I'd make my own.

# Requirements

  * Ruby 1.9.3 (though it might work on other versions)
  * MongoDB

# How to run it

First, populate the DB by running:

```
rake update
```

Then run a local instance:

```
rake server
```

You should be able to use any Rack-compatible server, since I included a config.ru file.

# How to use it

The server has just two methods:

### GET /theaters

It returns a list of theaters, along with their names and URLs:

```
[
    {
        "id": "508b4bcf67e6e2a56e000001",
        "name": "Alto las Condes",
        "lat": 0,
        "lng": 0
    },
    {
        "id": "508b4bd067e6e2a56e000019",
        "name": "Plaza Oeste",
        "lat": 0,
        "lng": 0
    }
]
```

### GET /theaters/:id/movies

Returns a list of movies on that theater, with their showtimes:

```
[
    {
        "name": "(Pre) Siniestro (Subtitulada)",
        "showtimes": [
            "21:40",
            "00:20"
        ]
    },
    {
        "name": "360  (Subtitulada)",
        "showtimes": [
            "19:45"
        ]
    },
]
```

# What's Next?

It currently only parses Cinemark and Cine Hoyts, so there's that. Here's a list of what's coming:

  * Movie theater locations
  * More movie theaters

# Want to contribute?

Fork, create a feature branch and create a pull request.

# License

Copyright (C) 2012 Ian Murray

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
