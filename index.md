---
layout: default
title: The Internate
---

The personal website of Nate Smith, a software developer from Toronto.

You should follow me on:

* [Twitter](https://twitter.com/nwjsmith)
* [GitHub](https://github.com/nwjsmith)
* [Speaker Deck](https://speakerdeck.com/nwjsmith)
* [LinkedIn](https://ca.linkedin.com/in/nwjsmith)

# Posts
{% for post in site.posts %}
* <a href="{{ post.url }}">{{ post.title }}</a> - {{ post.date | date_to_string }}
{% endfor %}

