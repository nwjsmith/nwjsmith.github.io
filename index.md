---
layout: default
title: The Internate
---

The personal website of Nate Smith, a software developer from Toronto.

You should follow me on:

* [Bluesky](https://github.com/profile/theinternate.com)
* [GitHub](https://github.com/nwjsmith)

# Posts
{% for post in site.posts %}
* <a href="{{ post.url }}">{{ post.title }}</a> - {{ post.date | date_to_string }}{% endfor %}

# Projects
* [generators.graph](https://github.com/nwjsmith/generators.graph) - Graph generators for [test.check](https://github.com/clojure/test.check).
* [Thumbtack](https://github.com/nwjsmith/thumbtack) - The best Ruby Pinboard API client.
* [Pseudo](https://github.com/nwjsmith/pseudo) - A tiny test double library.
