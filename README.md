# Movie Search App

This Flutter application enables users to search for movies utilizing the OMDb API.

## Features

- Search for movies by title
- Incrementally load additional results upon scrolling
- View detailed information about selected movies
- Efficient image caching for movie posters

## Packages Used

- **flutter_riverpod** — for state management
- **cached_network_image** — to cache and display images efficiently
- **shimmer** — to provide a placeholder loading effect for images
- **http** — to handle API requests

## Assumptions

- The home screen includes a search functionality instead of displaying trending movies, 
as the OMDb API does not offer a trending movies endpoint.

---
